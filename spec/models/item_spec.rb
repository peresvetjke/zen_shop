require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:item_1)        { create(:item) }
  let!(:item_2)        { create(:item) }

  let!(:user_A)        { create(:user) }
  let!(:cart_A)        { user_A.cart }
  let!(:cart_item_1)   { cart_A.cart_items.create(item: item_1, quantity: 2) }
  let!(:cart_item_2)   { cart_A.cart_items.create(item: item_2, quantity: 2) }
  let!(:user_B)        { create(:user) }
  let!(:cart_B)        { user_B.cart }
  let!(:cart_item_3)   { cart_B.cart_items.create(item: item_1, quantity: 2) }
  let!(:cart_item_4)   { cart_B.cart_items.create(item: item_2, quantity: 2) }

  subject { build(:item) }

  describe 'validations' do
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_numericality_of(:weight_gross_gr).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_one(:stock).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:order_items) }
    it { should have_many(:orders).through(:order_items) }
  end

  describe "#rating" do
    context "with reviews" do
      let!(:review_1) { create(:review, item: item_1, rating: 4) }
      let!(:review_2) { create(:review, item: item_1, rating: 5) }

      it "returns average reviews value" do
        expect(item_1.rating).to eq 4.5
      end
    end

    context "without reviews" do
      it "returns nil" do
        expect(item_2.rating).to be_nil
      end
    end
  end
end