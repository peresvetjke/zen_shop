class ConversionRate < ApplicationRecord
  validates :from,  presence: true
  validates :to,    presence: true
  validates :rate,  presence: true
  
  validates :to, uniqueness: { scope: :from }

  def self.exchange(money, currency_to)
    rate = ConversionRate.find_by(from: money.currency.iso_code, to: currency_to).rate
    Money.new(money.cents * rate, currency_to)
  end
end
