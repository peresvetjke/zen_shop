FactoryBot.define do
  factory :order_item do
    association :item, factory: :item
    unit_price { Money.new(100_00, "USD") }
    quantity   { 5 }
  end
end
