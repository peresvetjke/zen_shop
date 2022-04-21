class Item < ApplicationRecord
  after_create_commit { broadcast_append_to "items", partial: "admin/items/item" }
  after_update_commit { broadcast_replace_to "items", partial: "admin/items/item" }
  after_destroy_commit { broadcast_remove_to "items" }

  belongs_to :category
  has_one    :stock, dependent: :destroy
  has_many   :subscriptions, dependent: :destroy
  has_many   :reviews, dependent: :destroy
  has_many   :order_items
  has_many   :orders, through: :order_items
  has_one_attached :image

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_gross_gr, numericality: { greater_than: 0, integer: true }

  monetize :price_cents, as: "price"

  after_create :create_stock

  scope :arrived_items_for_follower, ->(follower) { Item.joins(:stock, :subscriptions).
                                                      where("stocks.storage_amount > ? AND subscriptions.user_id = ?", 0, follower.id) }

  def self.search(query)
    words = query.split.map(&:downcase)
    words.inject(Item.search_word words.first) { |result, word| result.or(Item.search_word word) }
  end

  def rating
    reviews.present? ? reviews.average(:rating).to_f : nil
  end

  private

  def self.search_word(word)
    Item.where("lower(title) LIKE ? OR lower(description) LIKE ?", "%#{word}%", "%#{word}%")
  end
end