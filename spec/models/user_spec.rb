require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)          { create(:user) }
  let(:other_user)    { create(:user) }
  let(:order)         { create(:order, user: user) }    
  let(:item)          { create(:item) }
  let(:subscription)  { create(:subscription, user: user, item: item) }

  describe 'associations' do
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_one(:bitcoin_wallet).dependent(:destroy) }
    it { should have_many(:bitcoin_purchases).through(:bitcoin_wallet).dependent(:destroy) }
    it { should have_many(:cart_items).through(:cart) }
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe "#subscribe!" do
    subject { user.subscribe!(item: item) }

    context "when unsubscribed" do
      it "creates subscription" do
        expect{subject}.to change(Subscription, :count).by(1)
      end
    end
    
    context "when subscribed" do
      it "deletes subscription" do
        subscription
        expect{subject}.to change(Subscription, :count).by(-1)
      end
    end
  end

  describe "#subscribed?" do
    context "when subscribed" do
      it "returns true" do
        subscription
        expect(user.subscribed?(item: item)).to eq true
      end
    end

    context "when not subscribed" do
      it "returns false" do
        expect(user.subscribed?(item: item)).to eq false
      end
    end
  end

  describe "#owner_of?" do
    context "when owner" do
      it "returns true" do
        expect(user.owner_of?(order)).to eq true
      end
    end

    context "when not owner" do
      it "returns false" do
        expect(other_user.owner_of?(order)).to eq false
      end
    end
  end

  describe "#admin?" do
    let(:admin) { create(:user, type: "Admin") }

    context "when admin" do
      it "returns true" do
        expect(admin.admin?).to eq true
      end
    end

    context "when not admin" do
      it "returns false" do
        expect(user.admin?).to eq false
      end
    end
  end
end