require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:price)         { Money.from_cents(1000_00, "RUB") }
  let(:item)          { create(:item, price: price, weight_gross_gr: 500) }
  let(:user)          { create(:user) }
  let!(:cart_item)    { user.cart.cart_items.create(item: item, amount: 2) }
  let(:address_attributes)  { { postal_code: 101000 } }

  let(:order_draft)   { build(:order, :no_items, params) }

  describe "associations" do
    # it { should belong_to(:user) } -- duplicates #enough_money validation where user is called
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
  end

################## Shared ################## 

  shared_examples "create order" do
    it "creates order" do
      expect{ subject }.to change(Order, :count)
    end

    it "clears cart" do
      cart_items_count = user.cart.cart_items.count
      expect(cart_items_count).to be > 0
      subject
      expect(user.cart.cart_items.reload.count).to eq 0
    end

    it "returns true" do
      expect(subject).to eq true
    end
  end

  shared_examples "no changes" do
    it "does not create order" do
      expect{ subject }.not_to change(Order, :count)
    end

    it "does not change cart items count" do
      cart_items_count = user.cart.cart_items.count
      subject
      expect(user.cart.cart_items.reload.count).to eq cart_items_count
    end

    it "returns false" do
      expect(subject).to eq false
    end
  end

  shared_examples "common" do
    describe "no delivery type" do
      let(:delivery_type) { nil }
      it_behaves_like "no changes"
    end

    describe "no items" do
      let(:cart_item) { }
      it_behaves_like "no changes"
    end

    describe "no money" do
      let(:user) { create(:user, :no_money) }
      it_behaves_like "no changes"
    end
  end

##########################################

  describe ".post_from_cart!" do
    subject { Order.post_from_cart!(order_draft) }

    describe "self-pickup" do
      let(:delivery_type) { 0 }
      let(:params) {{ 
        user: user, 
        delivery_type: delivery_type 
      }}

      it_behaves_like "common"

      describe "with delivery" do
        before { order_draft.build_delivery }    
        it_behaves_like "no changes"
      end
      
      describe "no delivery" do
        it_behaves_like "create order"
      end

      describe "no address" do
        it_behaves_like "create order"
      end

      describe "valid" do
        it_behaves_like "create order"
      end
    end

    describe "russian post" do
      let(:delivery_type) { 1 }
      let(:params) {{ 
        user: user, 
        delivery_type: delivery_type, 
        address_attributes: address_attributes 
      }}

      it_behaves_like "common"

      describe "no delivery" do
        before { order_draft.delivery = nil }
        it_behaves_like "no changes"
      end

      describe "no address" do
        before { order_draft.address = nil }
        it_behaves_like "no changes"
      end

      describe "valid" do
        it_behaves_like "create order"
      end
    end
  end

  describe "instance methods" do
    subject { create(:order) }

    describe "#sum" do
      it "returns total sum of items" do
        sum = subject.order_items.map { |order_item| order_item.unit_price * order_item.quantity }.sum
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