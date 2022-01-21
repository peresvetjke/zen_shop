class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  def total_sum
    cart_items.map { |cart_item| cart_item.item.price * cart_item.amount }.sum
  end
end
