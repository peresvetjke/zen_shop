class Address < ApplicationRecord
  has_many :deliveries, dependent: :destroy
end
