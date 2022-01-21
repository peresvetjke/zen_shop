require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:price) { Money.from_cents(1000_00, "RUB") }
  let(:item)  { create(:item, price: price, weight_gross_gr: 500) }
  let(:user)  { create(:user) }
  let(:order) {
    Order.create(
        user: user, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2],
        delivery_attributes: {delivery_type: 1},
        address_attributes: {postal_code: 101000}
      )
  }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
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