FactoryBot.define do
  factory :wallet do
    type { 0 }
    association :user, factory: :user
    balance { Money.new(1_0000_0000, "BTC") }
  end
end
