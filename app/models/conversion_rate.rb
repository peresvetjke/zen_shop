class ConversionRate < ApplicationRecord
  validates :from,  presence: true
  validates :to,    presence: true
  validates :rate,  presence: true
  
  validates :to, uniqueness: { scope: :from }

  def self.exchange(money, to)
    from = money.currency.iso_code

    if to == from
      money
    else
      rate = ConversionRate.find_by(from: from, to: to).rate
      MoneyRails.configure { |config| config.add_rate(from, to, rate) }
      money.exchange_to(to)
    end
  end
end
