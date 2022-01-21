class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  validates :amount, numericality: { greater_than_or_equal_to: 1,  only_integer: true }
end