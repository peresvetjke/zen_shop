require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)          { create(:user) }
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
end
