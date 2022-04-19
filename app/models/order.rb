class Order < ApplicationRecord
  enum delivery_type: { "Self-pickup" => 0, "Delivery" => 1 }

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery
  has_one :payment, dependent: :destroy

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :payment, reject_if: :all_blank, allow_destroy: true

  validates :delivery_type, presence: true
  validates_associated :order_items
  validates :order_items, presence: true
  validates_associated :payment
  validates :payment, presence: true
  validates_associated :delivery,       if: -> { delivery_type == "Delivery" }
  validates :delivery, presence: true,  if: -> { delivery_type == "Delivery" }
  validates :delivery, absence: true,   if: -> { delivery_type == "Self-pickup" }
  validates_associated :address,        if: -> { delivery_type == "Delivery" }
  validates :address, presence: true,   if: -> { delivery_type == "Delivery" }
  validates :address, absence: true,    if: -> { delivery_type == "Self-pickup" }

  before_validation :copy_cart, unless: -> { order_items.present? }

  def self.post_from_cart!(order:, wallet_id:)
    wallet = Wallet.find(wallet_id)
    ActiveRecord::Base.transaction do
      order.copy_cart

      wallet.payments.create!(
        order: order, 
        amount_cents: order.total_cost.cents, 
        amount_currency: wallet.currency
      )

      order.save!
      


      # wallet.payments.create!(order: order, amount_cents: order.total_cost.cents, amount_currency: wallet.currency)

      order.user.cart.empty!
      true
    rescue # ActiveRecord::RecordInvalid => exception
      false
    end
    
  end

  def total_cost
    if delivery_type == "Self-pickup" 
      ConversionRate.exchange(sum, currency) 
    else
      ConversionRate.exchange(sum, currency) + ConversionRate.exchange(delivery.cost, currency)
    end
  end

  def sum
    sum = order_items.map { |i| i.price * i.quantity }.sum
    ConversionRate.exchange(sum, currency)
  end

  def weight
    order_items.map { |i| i.item.weight_gross_gr * i.quantity }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  def copy_cart
    user.cart.cart_items.each do |cart_item|
      order_items.new(item: cart_item.item,
                      quantity: cart_item.quantity
      )
    end
    self
  end
end
