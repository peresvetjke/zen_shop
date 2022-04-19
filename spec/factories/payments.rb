FactoryBot.define do
  factory :payment do
    association :wallet, factory: :wallet
    association :order, factory: :order
    amount_cents { 1 }
    amount_currency { "USD" }
  end
end
