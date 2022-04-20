class Payment < ApplicationRecord
  belongs_to :wallet
  belongs_to :order

  delegate :user, to: :wallet

  validates :amount_cents, numericality: { greater_than: 0 }
  validate :matching_user,           if: -> { order.present? && wallet.present? }
  validate :matching_currency,       if: -> { wallet.present? }
  # validate :validate_enough_money,   if: ->  {  order.present? && 
  #                                               order.delivery_type.present? && order.order_items.present? &&
  #                                                 ( order.delivery_type == "Self-pickup" || 
  #                                                   ( order.delivery_type == "Delivery" && order.delivery.present? && order.address.present? ) 
  #                                                 )
  #                                            }

  monetize :amount_cents, as: "amount"

  private

  def matching_currency
    unless wallet.currency == amount_currency
      errors.add :amount_currency, "does not match wallet currency: #{wallet.currency}"
    end
  end

  def matching_user
    unless wallet.user == order.user
      errors.add :order, "does not match to wallet's user."
    end
  end
end
