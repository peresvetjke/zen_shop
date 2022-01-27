require 'rails_helper'

RSpec.describe BitcoinPurchase, type: :model do
  subject { build(:bitcoin_purchase) }

  describe "associations" do
    it { should belong_to(:bitcoin_wallet) }
    it { should belong_to(:order) }

    it "belongs to user" do
      expect(subject.user.class).to be < User
    end
  end
end
