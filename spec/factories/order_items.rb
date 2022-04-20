FactoryBot.define do
  factory :order_item do
    order { nil }
    association :item, factory: :item
    quantity   { 5 }
  end
end
