class Order < ApplicationRecord
  MINIMUM_SUM = Money.new(1_00, "RUB")

  enum status:  { 
                  "New"                   => 0,
                  "Processing"            => 1,
                  "Wait for self-pickup"  => 2,
                  "On delivery"           => 3,
                  "Delivered"             => 4
                }

  belongs_to :user
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery
  has_one :bitcoin_purchase, dependent: :destroy
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery,    reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address,     reject_if: :all_blank, allow_destroy: true

  validate :validate_at_least_one_order_item
  validate :validate_at_least_one_delivery
  validate :validate_minimum_sum,     if: -> { delivery && delivery.delivery_type != "Self-pickup" }
  validate :validate_address_exists,  if: -> { delivery && delivery.delivery_type != "Self-pickup" }
  validate :validate_enough_money,    if: -> { delivery && address && has_minimum_sum? }

  after_create :place_order
  after_commit :send_note

  def total_sum_rub
    order_items.inject(0) { |sum, order_item| sum + order_item.unit_price * order_item.quantity }
  end

  def payment_amount_rub
    total_sum_rub + delivery.cost_rub
  end

  def total_gross_weight_gr
    order_items.inject(0) { |sum, order_item| order_item.item.weight_gross_gr * order_item.quantity }
  end

  def build_address(params)
    self.address = Address.new(params)
  end
  
  private

  def place_order
    to_be_charged = BitcoinWallet.rub_to_btc(money_rub: payment_amount_rub)
    create_bitcoin_purchase!(bitcoin_wallet: user.bitcoin_wallet, amount_btc: to_be_charged)
    user.cart.empty!
  end

  def send_note
    NotificationSender.new.send_order_update_newsletter(order: self)
  end

  def has_minimum_sum?
    total_sum_rub >= MINIMUM_SUM
  end

  def validate_at_least_one_delivery
    errors.add :base, "Must have at least one Delivery." unless delivery.present?
  end
  
  def validate_at_least_one_order_item
    errors.add :base, "Must have at least one line item." unless order_items.present?
  end

  def validate_enough_money
    to_be_charged = BitcoinWallet.rub_to_btc(money_rub: payment_amount_rub)
    insufficient = to_be_charged - user.bitcoin_wallet.available_btc
    errors.add :base, "Not enough BTC for an order. Please replenish your wallet for #{insufficient}." if insufficient > 0
  end

  def validate_minimum_sum
    errors.add :base, "Declared value can't be less than 1 RUB" unless has_minimum_sum?
  end
  
  def validate_address_exists
    errors.add :base, "Must have address." if address.nil?
  end
end
