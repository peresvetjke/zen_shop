class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :amount, numericality: { greater_than_or_equal_to: 1,  only_integer: true }

  delegate :price, to: :item
end