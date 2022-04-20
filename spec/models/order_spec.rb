require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user)           { create(:user) }
  let!(:item)          { create(:item) }
  let!(:cart_item)      { create(:cart_item, cart: user.cart, item: item) }
  let(:order_draft)    { build(:order, :no_items, user: user) }

  describe "associations" do
    subject { order_draft }

    it { should belong_to(:user) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
    it { should have_one(:payment).dependent(:destroy) }
  end

  describe "validations" do
    subject { order_draft }

    it { should validate_presence_of(:delivery_type) }
    
    describe "validate presence of items" do
      describe "with cart items" do
        it "valid" do
          expect(subject).to be_valid
        end
      end

      describe "no cart items" do
        before { cart_item.destroy }

        it "not valid" do
          expect(subject).not_to be_valid
        end
      end
    end

    describe "validate enough money" do
      describe "sufficient" do
        it "valid" do
          expect(subject).to be_valid
        end
      end

      describe "insufficient" do
        before { user.wallet.update!(balance_cents: 0) }

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
    let(:wallet)        { user.wallet }
    let(:order_draft)   { build(:order, :no_items, :no_payment, user: user) }

    subject { Order.post_from_cart!(order: order_draft, wallet_id: wallet.id) }

    describe "valid order draft" do
      before { cart_item }

      it "creates order" do
        expect{ subject }.to change(Order, :count).by(1)
      end

      it "deletes cart items" do
        expect{ subject }.to change(CartItem, :count).by(-1)
      end

      it "reduces storage amount" do
        storage_amount = item.stock.storage_amount
        subject
        expect(item.stock.reload.storage_amount).to be < storage_amount
      end

      it "creates payment" do
        expect{ subject }.to change(Payment, :count).by(1)
      end      

      it "reduces wallet balance" do
        wallet_balance = wallet.balance
        subject
        expect(wallet.reload.balance).to be < wallet_balance
      end

      it "returns order" do
        expect(subject).to be_instance_of Order
      end
    end

    describe "invalid order draft" do
      shared_examples "no transaction" do
        it "does not create order" do
          expect{ subject }.not_to change(Order, :count)
        end

        it "does not delete cart items" do
          expect{ subject }.not_to change(CartItem, :count)
        end

        it "does not change storage amount" do
          storage_amount = item.stock.storage_amount
          subject
          expect(item.stock.reload.storage_amount).to eq storage_amount
        end

        it "does not create payment" do
          expect{ subject }.not_to change(Payment, :count)
        end      

        it "does not reduce wallet balance" do
          wallet_balance = wallet.balance
          subject
          expect(wallet.reload.balance).to eq wallet_balance
        end

        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      describe "no order items" do
        before { cart_item.destroy }

        it_behaves_like "no transaction"
      end

      describe "no goods" do
        before { 
          cart_item 
          cart_item.item.stock.update!(storage_amount: 0)
        }

        it_behaves_like "no transaction"
      end

      describe "no money" do
        before { 
          cart_item 
          wallet.update!(balance: Money.new(0, wallet.currency))
        }

        it_behaves_like "no transaction"
      end
    end
  end

  describe "instance methods" do
    

    describe "#sum" do
      subject { order.sum }

      describe "no items" do
        let!(:order) { build(:order, :no_items, :no_payment) }

        it "returns zero Money instance" do
          expect(subject).to eq Money.new(0, subject.currency)
        end
      end

      describe "with items" do
        let!(:order) { build(:order) }

        it "returns total sum of items" do
          sum = order.order_items.map { |order_item| order_item.price * order_item.quantity }.sum
          expect(subject).to be > 0
          expect(subject).to eq sum
          expect(subject).to be_instance_of Money
        end
      end
    end

    describe "#weight" do
      let!(:order) { build(:order) }

      it "returns total weight" do
        weight = order.order_items.map { |order_item| order_item.item.weight_gross_gr * order_item.quantity }.sum
        expect(order.weight).to be > 0
        expect(order.weight).to eq weight
      end
    end

    describe "#total_cost" do
      describe "no items" do
        let(:order) { build(:order, :no_items) }

        it "returns Money instance" do
          expect(order.total_cost).to be_instance_of Money
        end
      end

      describe "with items" do
        let(:order) { create(:order, delivery_type: delivery_type) }

        describe "Self-Pickup" do
          let(:delivery_type) { 0 }

          it "returns order sum" do
            expect(order.total_cost).to eq (order.sum)
          end
        end

        describe "Russian Post" do
          let(:delivery_type) { 1 }

          it "returns order sum + delivery cost" do
            expect(order.sum).to be > 0 
            expect(order.sum).to be > order.delivery.cost
            expect(order.total_cost).to eq (order.sum + order.delivery.cost)
          end
        end
      end
    end

    describe "#copy_cart" do
      let!(:user) { create(:user) }
      let(:order) { build(:order, :no_items, user: user) }
      
      subject { order.copy_cart }

      describe "no cart items" do
        before { cart_item.destroy }

        it "does not change order" do
          subject
          expect(order.order_items.size).to eq 0
        end
      end

      describe "with cart items" do
        let!(:cart_item) { create(:cart_item, cart: user.cart) }

        it "copies cart items to order items" do
          subject
          expect(subject.order_items.size).to eq 1
        end
      end
    end

    describe "#goods_issue!" do
      let(:order)       { create(:order) }
      let(:order_item)  { order.order_items.first }
      let(:stock)       { order_item.item.stock }

      before do
        order.order_items.each do |i|
          i.item.stock.update!(storage_amount: 10)
        end
      end

      describe "enough storage amount" do
        it "reduces storage amount of items" do
          storage_amount = stock.storage_amount
          order.goods_issue!
          expect(stock.reload.storage_amount).to be < storage_amount
        end
      end

      describe "insufficient storage amount" do
        before { order_item.update(quantity: 11) }

        it "raises error" do
          expect{ order.goods_issue! }.to raise_error
        end
      end
    end
  end
end