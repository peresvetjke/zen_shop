FactoryBot.define do
  factory :order do
    association :user, factory: :user
    delivery_type { 0 }
    order_items   { build_list(:order_item, 5) }
       
    after(:build) do |order, evaluator|
      unless order.delivery_type == "Self-pickup"
        order.address = FactoryBot.build(:address)
      end
    end

    trait :no_items do
      after(:build) do |order, evaluator|
        order.order_items.destroy_all
      end
    end
  end
end
