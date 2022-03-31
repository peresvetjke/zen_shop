FactoryBot.define do
  factory :default_address do
    association :user, factory: :user
    association :address, factory: :address
  end
end
