class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  monetize :unit_price_cents, as: "unit_price"

  validates :quantity, numericality: { greater_than_or_equal_to: 1,  only_integer: true }
end