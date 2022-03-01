class DefaultAddress < ApplicationRecord
  belongs_to :user
  belongs_to :address
end
