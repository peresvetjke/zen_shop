require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:price)               { Money.from_cents(1000_00, "RUB") }
  let(:user)                { create(:user) }
  let(:order)               { create(:order, :valid, user: user) }
  let(:service)             { double(NotificationSender) }

  describe "associations" do
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_one(:delivery).dependent(:destroy) }
    it { should have_one(:bitcoin_purchase).dependent(:destroy) }
  end

  describe "validations" do
    it "doesn't allow create order without any item" do
      expect(build(:order, :without_items)).to_not be_valid
    end
    
    it "doesn't allow create order without delivery" do
      expect(build(:order, :without_delivery)).to_not be_valid
    end

    it "doesn't allow create order without sufficient fund" do
      expect(build(:order, :valid, user: create(:user, :no_money))).to_not be_valid
    end

    describe "doesn't allow create order without address" do
      context "russian post delivery" do
        it "doesn't allow create order without address" do
          expect(build(:order, :without_address_with_delivery)).to_not be_valid
        end
      end

      context "self pickup" do
        it "allows to create order without address" do
          expect(build(:order, :without_address_self_pickup)).to be_valid
        end
      end
    end

    describe "order's minimum sum validation" do
      context "russian post delivery" do
        it "doesn't allow to create order below minimum sum" do
          expect(build(:order, :zero_sum_with_delivery)).to_not be_valid   
        end
      end

      context "self pick up" do
        it "allows to create order" do
          expect(build(:order, :zero_sum_self_pickup)).to be_valid   
        end
      end
    end
  end

  describe "#place_order" do
    subject { order }

    it "creates purchase in db" do
      expect{subject}.to change(BitcoinPurchase, :count).by(1)
    end

    it "charges off the customer" do
      expect{subject}.to change(user.bitcoin_wallet, :available_btc)
    end

    it "empty current cart" do
      subject
      expect(user.cart.cart_items.count).to eq 0
    end
  end

  describe "#total_sum_rub" do
    it "returns total sum of items" do
      expect(order.total_sum_rub).to eq Money.new(500_00, "RUB")
    end
  end

  describe "#payment_amount_rub" do
    it "returns total payment amount for the order (incl. shipping)" do
      expect(order.payment_amount_rub).to eq (order.total_sum_rub + order.delivery.cost_rub)
    end
  end

  describe "#total_gross_weight_gr" do
    it "returns total weight" do
      expect(order.total_gross_weight_gr).to eq 2000
    end
  end

  describe "#send_note" do
    it "calls service" do
      allow(NotificationSender).to receive(:new).and_return(service)
      expect(service).to receive(:send_order_update_newsletter).twice
      order = create(:order, :valid)
      order.update(status: "Processing")
    end
  end
end