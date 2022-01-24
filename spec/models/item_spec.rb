require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:item_1)        { create(:item) }
  let!(:item_2)        { create(:item) }

  let!(:user_A)        { create(:user) }
  let!(:cart_A)        { user_A.cart }
  let!(:cart_item_1)   { cart_A.cart_items.create(item: item_1, amount: 2) }
  let!(:cart_item_2)   { cart_A.cart_items.create(item: item_2, amount: 2) }
  let!(:user_B)        { create(:user) }
  let!(:cart_B)        { user_B.cart }
  let!(:cart_item_3)   { cart_B.cart_items.create(item: item_1, amount: 2) }
  let!(:cart_item_4)   { cart_B.cart_items.create(item: item_2, amount: 2) }

  subject { build(:item) }

  describe 'validations' do
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_numericality_of(:weight_gross_gr).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_one(:stock) }
  end

  describe "#available_amount" do
    before {
      item_1.stock.update(storage_amount: 10)
      item_1.stock.save
      item_2.stock.update(storage_amount: 10)
      item_2.stock.save
    }

    it "returns available amount" do
      expect(item_1.available_amount).to eq 6
    end
  end
end