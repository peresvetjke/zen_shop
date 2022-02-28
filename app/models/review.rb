class Review < ApplicationRecord
  belongs_to :item
  belongs_to :author, foreign_key: "author_id", class_name: "User"

  validates :body, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5, only_integer: true }
end
