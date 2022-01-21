require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:price) { Money.from_cents(250_00, "RUB") }
  let(:item)  { create(:item, price: price, weight_gross_gr: 1000) }
  let(:user)  { create(:user) }
  let(:order) {
    Order.create(
        user: user, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2]
      )
  }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items).dependent(:destroy) }
  end

  describe "#total_sum" do
    it "returns total sum" do
      expect(order.total_sum).to eq Money.new(500_00, "RUB")
    end
  end
end