class Address < ApplicationRecord
  has_many :deliveries, dependent: :destroy

  validates :postal_code, presence: true
end
