class Item < ApplicationRecord
  after_create_commit { broadcast_append_to "items", partial: "admin/items/item" }
  after_update_commit { broadcast_replace_to "items", partial: "admin/items/item" }
  after_destroy_commit { broadcast_remove_to "items" }

  belongs_to :category
  has_one    :stock
  has_many   :subscriptions, dependent: :destroy
  has_many   :reviews, dependent: :destroy
  has_one_attached :image

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_gross_gr, numericality: { greater_than: 0, integer: true }

  monetize :price_cents, as: "price"

  after_create :create_stock

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  scope :arrived_items_for_follower, ->(follower) { Item.joins(:stock, :subscriptions).
                                                      where("stocks.storage_amount > ? AND subscriptions.user_id = ?", 0, follower.id) }

  def available_amount
    reserved = CartItem.where(item: self).pluck(:amount).sum
    stock.storage_amount - reserved
  end

  def rating
    reviews.present? ? reviews.average(:rating).to_f : nil
  end
end