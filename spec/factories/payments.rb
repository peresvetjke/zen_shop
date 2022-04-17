FactoryBot.define do
  factory :payment do
    wallet { nil }
    order { nil }
    amount_cents { 1 }
    amount_currency { "MyString" }
  end
end
