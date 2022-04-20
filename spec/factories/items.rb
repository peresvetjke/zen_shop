FactoryBot.define do
  factory :item do
    title { generate(:title) }
    description { "Description" }
    association :category, factory: :category
    price { Money.from_cents(50_00, "USD") }
    weight_gross_gr { 1000 }

    after(:create) do |item|
      item.stock.update(storage_amount: 100)
      item.stock.save
    end
  end
end