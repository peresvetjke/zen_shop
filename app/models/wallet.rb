class Wallet < ApplicationRecord
  
  CURRENCIES = { "BitcoinWallet" => "BTC" }

  enum type: { "BitcoinWallet" => 0 }

  monetize :balance_cents, as: "balance"

  belongs_to :user
  has_many :payments, dependent: :destroy

  validates :type, uniqueness: { scope: :user_id, 
    message: "already exists for user" }
  validate :currency_relevance

  def self.update_balances
    raise "Not implemented for abstract class."
  end

  private

  def currency_relevance
    unless balance_currency == CURRENCIES[type]
      errors.add :base, "Wrong currency"
    end
  end
end
