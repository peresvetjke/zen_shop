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

  before_validation :copy_cart,     unless: -> { order_items.present? }
  before_validation :build_payment, if:     -> { delivery_type.present? && 
                                                 order_items.present? &&
                                                 ((delivery_type == "Self-pickup") ||
                                                  (delivery_type == "Delivery") && delivery.present? && address.present?
                                                 )
                                               }

  validates :delivery_type, presence: true
  validates_associated :order_items
  validates :order_items, presence: true
  validates_associated :delivery,       if: -> { delivery_type == "Delivery" }
  validates :delivery, presence: true,  if: -> { delivery_type == "Delivery" }
  validates :delivery, absence: true,   if: -> { delivery_type == "Self-pickup" }
  validates_associated :address,        if: -> { delivery_type == "Delivery" }
  validates :address, presence: true,   if: -> { delivery_type == "Delivery" }
  validates :address, absence: true,    if: -> { delivery_type == "Self-pickup" }
  validate  :validate_enough_money,     if: -> { delivery_type.present? && 
                                                 order_items.present? && 
                                                 ((delivery_type == "Self-pickup") ||
                                                  (delivery_type == "Delivery") && delivery.present? && address.present?
                                                 )
                                               }

  def self.post_from_cart!(order)
    ActiveRecord::Base.transaction do
      order.copy_cart
      order.goods_issue!
      order.save!
      order.build_payment.post!
      order.user.cart.empty!
      true
    rescue
      raise ActiveRecord::Rollback
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
    if order_items.empty?
      Money.new(0, currency)
    else
      sum = order_items.map { |i| i.price * i.quantity }.sum
      ConversionRate.exchange(sum, currency)
    end
  end

  def goods_issue!
    order_items.each do |i| 
      amount = i.item.stock.storage_amount - i.quantity
      i.item.stock.update!(storage_amount: amount)
    end
  end

  def weight
    order_items.map { |i| i.item.weight_gross_gr * i.quantity }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  def copy_cart
    user&.cart&.cart_items&.each do |cart_item|
      order_items.new(item: cart_item.item,
                      quantity: cart_item.quantity
      )
    end
    self
  end

  def build_payment
    payment = Payment.new(
      order_id: id,
      amount:   total_cost,
      wallet:   user&.wallet
    )
  end

  private

  def validate_enough_money
    if user.wallet.available < total_cost
      errors.add :base, "Not sufficient funds. Please replenish you wallet."
    end
  end


  # def validate_enough_money
  #   insufficient = ConversionRate.exchange(order.total_cost, wallet.currency) - wallet.available
    
  #   if insufficient > 0
  #     errors.add :base, "Not enough #{wallet.balance_currency} for an order. Please replenish your wallet for #{insufficient}."
  #   end
  # end
end
