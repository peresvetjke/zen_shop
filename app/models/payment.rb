class Payment < ApplicationRecord
  belongs_to :wallet
  belongs_to :order
end
