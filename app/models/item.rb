class Item < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_gross_gr, numericality: { greater_than: 0, integer: true }

  monetize :price_cents, as: "price"
end