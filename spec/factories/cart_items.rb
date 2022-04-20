FactoryBot.define do
  factory :cart_item do
    cart { nil }
    association :item, factory: :item
    quantity { 1 }
  end
end
