require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let!(:item) { create(:item) }
  let!(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1).only_integer }
    
    describe "stocks" do
      before { item.stock.update(storage_amount: 10) }

      context "new cart item" do
        it "doesn't allow to add item with no sufficient quantity available" do
          cart_item = user.cart.cart_items.create(item: item, quantity: 11)
          expect(cart_item).to_not be_valid
        end
      end

      context "existing one" do
        it "doesn't allow to update item with no sufficient quantity available" do
          cart_item = user.cart.cart_items.create(item: item, quantity: 5)
          cart_item.update(quantity: 20)
          expect(cart_item.reload.quantity).to eq 5
        end
      end
    end
  end
end
