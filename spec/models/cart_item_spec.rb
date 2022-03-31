require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let!(:item) { create(:item) }
  let!(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(1).only_integer }
    
    describe "stocks" do
      before { item.stock.update(storage_amount: 10) }

      context "new cart item" do
        it "doesn't allow to add item with no sufficient amount available" do
          cart_item = user.cart.cart_items.create(item: item, amount: 11)
          expect(cart_item).to_not be_valid
        end
      end

      context "existing one" do
        it "doesn't allow to update item with no sufficient amount available" do
          cart_item = user.cart.cart_items.create(item: item, amount: 5)
          cart_item.update(amount: 20)
          expect(cart_item.reload.amount).to eq 5
        end
      end
    end
  end
end
