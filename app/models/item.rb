class Item < ApplicationRecord
  belongs_to :category
  has_one    :stock

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_gross_gr, numericality: { greater_than: 0, integer: true }

  monetize :price_cents, as: "price"

  after_create :create_stock

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  def available_amount
    reserved = CartItem.where(item: self).pluck(:amount).sum
    stock.storage_amount - reserved
  end
end