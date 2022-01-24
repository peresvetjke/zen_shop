FactoryBot.define do
  factory :stock do
    association :item, factory: :item
    storage_amount { 100 }
  end
end
