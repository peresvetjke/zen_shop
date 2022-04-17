require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)          { create(:user) }
  let(:other_user)    { create(:user) }
  let(:order)         { create(:order, user: user) }    
  let(:item)          { create(:item) }
  let(:subscription)  { create(:subscription, user: user, item: item) }

  describe 'associations' do
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_many(:wallets).dependent(:destroy) }
    it { should have_one(:default_wallet).dependent(:destroy) }
    it { should have_one(:default_address).dependent(:destroy) }
    it { should have_many(:payments).through(:wallets).dependent(:destroy) }
    it { should have_many(:cart_items).through(:cart) }
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:authentications).dependent(:destroy) }
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
      let(:item) { create(:item) }
      let(:user) { create(:user) }

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

  describe ".find_for_oauth" do
    let(:auth)    { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('OmniAuthFinder') }

    it 'calls OmniAuthFinder' do
      expect(Omni::AuthFinder).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end