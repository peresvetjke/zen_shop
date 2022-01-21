require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user)              { create(:user) }
  let(:cart)              { user.cart }
  let(:item)              { create(:item, price: Money.from_cents(10000, "RUB")) }
  let(:another_item)      { create(:item, price: Money.from_cents(1500, "RUB")) }
  let(:cart_item)         { cart.cart_items.create(item: item, amount: 2) }
  let(:another_cart_item) { cart.cart_items.create(item: another_item, amount: 2) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:items).through(:cart_items) }
  end

  describe "#total_sum" do
    context "single position" do
      before { cart.cart_items.create(item: item) }
      
      it "returns item's price" do
        expect(cart.total_sum).to eq item.price
      end
    end

    context "few positions" do
      before {
        cart_item
        another_cart_item
      }
    
      it "returns calculated total sum" do
        expect(cart.total_sum).to eq Money.new(230_00, "RUB")
      end
    end
  end
end
