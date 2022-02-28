class Review < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :item
  belongs_to :author, foreign_key: "author_id", class_name: "User"
  has_rich_text :body

  validates :body, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true }
  validates :item, uniqueness: { scope: :author, message: I18n.t("reviews.errors.duplicated") }
end
