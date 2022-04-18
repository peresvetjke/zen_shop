class Order < ApplicationRecord
  enum delivery_type: { "Self-pickup" => 0, "Delivery" => 1 }

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :delivery_type, presence: true
  validates_associated :order_items
  validates :order_items, presence: true
  validates_associated :delivery,       if: -> { delivery_type == "Delivery" }
  validates :delivery, presence: true,  if: -> { delivery_type == "Delivery" }
  validates :delivery, absence: true,   if: -> { delivery_type == "Self-pickup" }
  validates_associated :address,        if: -> { delivery_type == "Delivery" }
  validates :address, presence: true,   if: -> { delivery_type == "Delivery" }
  validates :address, absence: true,    if: -> { delivery_type == "Self-pickup" }
  validate :validate_enough_money,      if: -> { delivery_type.present? && order_items.present? &&
                                                  ( delivery_type == "Self-pickup" || 
                                                    ( delivery_type == "Delivery" && delivery.present? ) 
                                                  )
                                          }

  before_validation :copy_cart, unless: -> { order_items.present? }

  # validates_with OrderValidator

  def self.post_from_cart!(order_draft)
    # binding.pry
    # order = order_draft.copy_cart

    # binding.pry

    ActiveRecord::Base.transaction do
      # order_draft.copy_cart
      order_draft.save!
      # purchase.create!
      order_draft.user.cart.empty!
    rescue ActiveRecord::RecordInvalid => exception
      exception
    #   false
    end
    # true
    # order
  end

  def total_cost
    # binding.pry
    if delivery_type == "Self-pickup" 
      ConversionRate.exchange(sum, currency) 
    else
      ConversionRate.exchange(sum, currency) + ConversionRate.exchange(delivery.cost, currency)
    end
  end

  def sum
    sum = order_items.map { |i| i.price * i.amount }.sum
    ConversionRate.exchange(sum, currency)
  end

  def weight
    order_items.map { |i| i.item.weight_gross_gr * i.amount }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  def copy_cart
    user.cart.cart_items.each do |cart_item|
      order_items.new(item: cart_item.item,
                      amount: cart_item.amount
      )
    end
    self
  end

  def validate_enough_money
    # binding.pry
    insufficient = ConversionRate.exchange(total_cost, currency) - user.wallet.balance
    
    if insufficient > 0
      errors.add :base, "Not enough #{user.wallet.balance_currency} for an order. Please replenish your wallet for #{insufficient}."
    end
  end
end
