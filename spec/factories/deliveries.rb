FactoryBot.define do
  factory :delivery do
    delivery_type { 0 }
    association :address, factory: :address    
  end
end
