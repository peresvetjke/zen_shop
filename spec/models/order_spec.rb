require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:price)           { Money.from_cents(1000_00, "RUB") }
  let(:item)            { create(:item, price: price, weight_gross_gr: 500) }
  let(:user)            { create(:user) }
  let(:user_no_money)   { create(:user, :no_money) }
  let(:order) {
    Order.create(
        user: user, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2],
        delivery_attributes: {delivery_type: 1},
        address_attributes: {postal_code: 101000}
      )
  }

  describe "associations" do
    # it { should belong_to(:user) } -- duplicates #enough_money validation where user is called
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
  end

  describe "validations" do
    let(:order_without_items) {
      Order.new(
        user: user, 
        order_items_attributes: [],
        delivery_attributes: {delivery_type: 1},
        address_attributes: {postal_code: 101000}
      )
    }

    let(:order_without_address) {
      Order.new(
        user: user, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2]
      )
    }

    let(:order) {
      Order.create(
        user: user_no_money, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2],
        delivery_attributes: {delivery_type: 1},
        address_attributes: {postal_code: 101000}
      )
    }

    it "doesn't allow create order without any item" do
      expect(order_without_items).to_not be_valid
    end
    
    it "doesn't allow create order without delivery" do
      expect(order_without_address).to_not be_valid
    end

    it "doesn't allow create order without sufficient fund" do
      expect(order).to_not be_valid
    end
  end

  describe "#total_sum" do
    it "returns total sum of items" do
      expect(order.total_sum).to eq Money.new(2000_00, "RUB")
    end
  end

  describe "#total_cost" do
    it "returns total cost of order (incl. delivery)" do
      expect(order.total_cost).to eq (order.total_sum + order.delivery.cost_rub)
    end
  end

  describe "#total_weight" do
    it "returns total weight" do
      expect(order.total_weight).to eq 1000
    end
  end
end