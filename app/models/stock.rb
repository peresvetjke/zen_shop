class Stock < ApplicationRecord
  belongs_to :item

  validates :storage_amount, numericality: { greater_than_or_equal_to: 0 }
end
