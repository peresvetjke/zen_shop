FactoryBot.define do
  factory :review do
    association :author, factory: :user
    association :item, factory: :item
    body { "MyText" }
    rating { 1 }
  end
end
