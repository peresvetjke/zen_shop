FactoryBot.define do
  factory :order do
    association :user, factory: :user
    order_items_attributes { [item_id: create(:item).id, unit_price: Money.from_cents(250_00, "RUB"), quantity: 2] }
  end
end
