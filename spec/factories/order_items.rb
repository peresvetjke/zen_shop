FactoryBot.define do
  factory :order_item do
    association :item, factory: :item
    quantity   { 5 }
  end
end
