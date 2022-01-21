FactoryBot.define do
  factory :order_item do
    association :item, factory: :item
    unit_price { 100000 }
    quantity   { 1 }
  end
end
