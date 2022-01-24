FactoryBot.define do
  factory :subscription do
    association :user, factory: :user
    association :item, factory: :item
  end
end