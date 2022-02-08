FactoryBot.define do
  factory :order do
    user { create(:user) }
  end

  trait :with_items do
    order_items_attributes { [item_id: create(:item).id, unit_price: Money.from_cents(250_00, "RUB"), quantity: 2] }
  end

  trait :with_free_items do
    order_items_attributes { [item_id: create(:item).id, unit_price: Money.from_cents(0_00, "RUB"), quantity: 2] }
  end

  trait :with_delivery do
    delivery_attributes { {delivery_type: 1} }
  end

  trait :self_pickup do
    delivery_attributes { {delivery_type: 0} }
  end

  trait :with_address do
    association :address, factory: :address
  end

  trait :without_items do
    with_delivery
    with_address
  end

  trait :without_delivery do
    with_items
    with_address
  end

  trait :without_address do
    with_items
    with_delivery
  end

  trait :zero_sum_with_delivery do
    with_free_items
    with_delivery
    with_address
  end

  trait :zero_sum_self_pickup do
    with_free_items
    self_pickup
    with_address
  end

  trait :without_address_with_delivery do
    with_free_items
    with_delivery
    with_address
  end

  trait :without_address_self_pickup do
    with_free_items
    self_pickup
    with_address
  end

  trait :valid do
    with_items
    with_delivery
    with_address
  end
end
