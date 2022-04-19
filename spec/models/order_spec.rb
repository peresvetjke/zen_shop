require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user)          { create(:user) }
  let(:cart_item)     { create(:cart_item, cart: user.cart) }
  let(:order_draft)   { build(:order, :no_items, user: user) }

  describe "associations" do
    # it { should belong_to(:user) } -- duplicates #enough_money validation where user is called
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
  end

  describe "validations" do
    subject { order_draft }

    it { should validate_presence_of(:delivery_type) }
    
    describe "validate presence of items" do
      describe "with cart items" do
        before { cart_item }
        
        it "valid" do
          expect(subject).to be_valid
        end
      end

      describe "no cart items" do
        it "not valid" do
          expect(subject).not_to be_valid
        end
      end
    end
        
    describe "self-pickup" do
      before { cart_item }
      
      let(:order_draft)   { build(:order, :no_items, user: user, delivery_type: 0) }

      it { should validate_absence_of(:delivery) }
    end

    describe "delivery" do
      
      before { cart_item }

      let(:order_draft)   { build(:order, :no_items, user: user, delivery_type: 1) }

      it { should validate_presence_of(:delivery) }
      it { should validate_presence_of(:address) }
    end
  end

  describe ".post_from_cart!" do
    subject { Order.post_from_cart!(order_draft) }

    describe "valid order draft" do
      before { cart_item }

      it "creates order" do
        expect{ subject }.to change(Order, :count).by(1)
      end

      it "deletes cart items" do
        expect{ subject }.to change(CartItem, :count).by(-1)
      end
    end

    describe "invalid order draft" do
      it "does not create order" do
        expect{ subject }.not_to change(Order, :count)
      end

      it "does not delete cart items" do
        expect{ subject }.not_to change(CartItem, :count)
      end
    end
  end

  describe "instance methods" do
    subject { create(:order) }

    describe "#sum" do
      it "returns total sum of items" do
        sum = subject.order_items.map { |order_item| order_item.price * order_item.quantity }.sum
        expect(subject.sum).to be > 0
        expect(subject.sum).to eq sum
      end
    end

    describe "#weight" do
      it "returns total weight" do
        weight = subject.order_items.map { |order_item| order_item.item.weight_gross_gr * order_item.quantity }.sum
        expect(subject.weight).to be > 0
        expect(subject.weight).to eq weight
      end
    end

    describe "#total_cost" do
      subject { create(:order, delivery_type: delivery_type) }

      describe "Self-Pickup" do
        let(:delivery_type) { 0 }

        it "returns order sum" do
          expect(subject.total_cost).to eq (subject.sum)
        end
      end

      describe "Russian Post" do
        let(:delivery_type) { 1 }

        it "returns order sum + delivery cost" do
          expect(subject.sum).to be > 0 
          expect(subject.sum).to be > subject.delivery.cost
          expect(subject.total_cost).to eq (subject.sum + subject.delivery.cost)
        end
      end
    end
  end
end