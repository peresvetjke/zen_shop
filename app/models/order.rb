class Order < ApplicationRecord
  MINIMUM_SUM = Money.new(1_00, "RUB")

  belongs_to :user
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validate :validate_at_least_one_order_item
  validate :validate_at_least_one_delivery
  validate :validate_minimum_sum, if:-> { delivery && delivery.delivery_type != "Self-pickup" }
  validate :validate_address_exists, if:-> { delivery && delivery.delivery_type != "Self-pickup" }
  validate :validate_enough_money, if: -> { delivery && has_minimum_sum? }

  def total_sum
    order_items.map { |order_item| order_item.unit_price * order_item.quantity }.sum
  end

  def total_cost
    total_sum + delivery.cost_rub
  end

  def total_weight
    order_items.map { |order_item| order_item.item.weight_gross_gr * order_item.quantity }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  private

  def has_minimum_sum?
    total_sum >= MINIMUM_SUM
  end

  def validate_at_least_one_delivery
    errors.add :base, "Must have at least one Delivery." unless delivery.present?
  end
  
  def validate_at_least_one_order_item
    errors.add :base, "Must have at least one line item." unless order_items.present?
  end

  def validate_enough_money
    liability = delivery.delivery_type == "Self-pickup" ? total_sum + delivery.cost_rub : total_sum
    insufficient = user.bitcoin_wallet.calculate_insufficient_btc_amount(money_rub: liability)
    errors.add :base, "Not enough BTC for an order. Please replenish your wallet for #{insufficient}." if insufficient > 0
  end

  def validate_minimum_sum
    errors.add :base, "Declared value can't be less than 1 RUB" unless has_minimum_sum?
  end
  
  def validate_address_exists
    errors.add :base, "Must have address." if address.nil?
  end
end
