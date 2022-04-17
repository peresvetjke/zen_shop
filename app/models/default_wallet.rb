class DefaultWallet < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
end
