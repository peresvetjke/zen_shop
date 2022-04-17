FactoryBot.define do
  factory :delivery do
    type { "RussianPostDelivery" }
    association :address, factory: :address
    association :order, factory: :order
  end
end
