require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:payments).dependent(:destroy) }
  end

  describe 'validations' do
    let!(:user) { create(:user) }

    it "does not allow to create duplicates per currency" do
      expect(user.wallet).not_to be_nil
      expect(build(:wallet, user: user, type: "BitcoinWallet")).not_to be_valid
    end
  end

  describe "#available" do
    let!(:user)     { create(:user) }
    let!(:wallet)   { user.wallet }
    
    describe "no payments" do
      it "returns wallet balance" do
        expect(wallet.available).to eq wallet.balance
      end
    end

    describe "with payments" do
      let!(:order) { create(:order, user: user) }
      # let!(:payment) { create(:payment, amount: Money.new(50000, "BTC"), wallet: wallet, order: create(:order, user: user)) }

      it "returns available money amount" do
        expect(wallet.available).to eq (wallet.balance - order.payment.amount)
      end
    end
  end
end
