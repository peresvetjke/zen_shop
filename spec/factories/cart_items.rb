FactoryBot.define do
  factory :cart_item do
    cart { nil }
    association :item, factory: :item
    amount { 1 }
  end
end
