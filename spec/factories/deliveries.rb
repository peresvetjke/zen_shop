FactoryBot.define do
  factory :delivery do
    delivery_type { 1 }
    association :address, factory: :address

    trait(:self_pickup) do
      delivery_type { 0 }
    end
  end
end
