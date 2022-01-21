FactoryBot.define do
  factory :item do
    title { generate(:title) }
    description { "Description" }
    association :category, factory: :category
    price { Money.from_cents(10000, "RUB") }
    weight_gross_gr { 1000 }
  end
end