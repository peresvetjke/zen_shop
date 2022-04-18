FactoryBot.define do
  factory :order_item do
    association :item, factory: :item
    amount   { 5 }
  end
end
