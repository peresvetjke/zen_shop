class Wallet < ApplicationRecord
  
  CURRENCIES = { "BitcoinWallet" => "BTC" }

  enum type: { "BitcoinWallet" => 0 }

  monetize :balance_cents, as: "balance"

  belongs_to :user
  has_many :payments, dependent: :destroy

  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :type, uniqueness: { scope: :user_id, 
    message: "already exists for user" }
  validate :validate_currency_relevance

  def self.update_balances
    raise "Not implemented for abstract class."
  end

  def available
    balance - Money.new(payments.pluck(:amount_cents).sum, currency)
  end

  def currency
    Wallet::CURRENCIES[type]
  end

  private

  def validate_currency_relevance
    unless balance_currency == CURRENCIES[type]
      errors.add :base, "Wrong currency"
    end
  end
end
