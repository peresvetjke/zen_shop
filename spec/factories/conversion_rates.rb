FactoryBot.define do
  factory :conversion_rate do
    from { "USD" }
    to { "BTC" }
    rate { 0.0000251001 }
  end
end
