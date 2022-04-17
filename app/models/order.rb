class Order < ApplicationRecord
  MINIMUM_SUM_RUB = Money.new(1_00, "RUB")

  enum delivery_type: { "Self-pickup" => 0, "Delivery" => 1 }

  belongs_to :user
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates_with OrderValidator

  def self.post_from_cart!(order_draft)
    ActiveRecord::Base.transaction do
      order_draft.copy_cart
      order_draft.save!
      # purchase.create!
      order_draft.user.cart.empty!
      true
    rescue
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
    sum = order_items.map { |order_item| order_item.unit_price * order_item.quantity }.sum
    ConversionRate.exchange(sum, currency)
  end

  def weight
    order_items.map { |order_item| order_item.item.weight_gross_gr * order_item.quantity }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  def copy_cart
    user.cart.cart_items.each do |cart_item|
      order_items.new(item: cart_item.item,
                      unit_price: cart_item.item.price,
                      quantity: cart_item.amount
      )
    end
  end
end
