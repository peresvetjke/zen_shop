class Item < ApplicationRecord
  belongs_to :category
  has_one    :stock
  has_many   :subscriptions, dependent: :destroy
  has_many   :reviews, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_gross_gr, numericality: { greater_than: 0, integer: true }

  monetize :price_cents, as: "price"

  after_create :create_stock

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  scope :arrived_items_for_follower, ->(follower) { Item.joins(:stock, :subscriptions).
                                                      where("stocks.storage_amount > ? AND subscriptions.user_id = ?", 0, follower.id) }

  def purchased_by?(user)
    user.cart.cart_items.find_by(item_id: id).present?
  end

  def available_amount
    reserved = CartItem.where(item: self).pluck(:amount).sum
    stock.storage_amount - reserved
  end
end