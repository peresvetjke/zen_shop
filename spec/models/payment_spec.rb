require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe "associations" do
    it { should belong_to(:wallet) }
    it { should belong_to(:order) }
  end

  describe "validations" do
    let!(:order)  { create(:order) }

    it { should validate_numericality_of(:amount_cents).is_greater_than(0) }

    describe "relevant user for order and wallet" do
      subject { build(:payment, order: order, wallet: wallet, amount_currency: wallet.currency) }

      describe "match" do
        let(:wallet) { order.user.wallet }

        it "is valid" do
          expect(subject).to be_valid
        end
      end

      describe "not match" do
        let(:wallet) { create(:user).wallet }

        it "is not valid" do
          expect(subject).not_to be_valid
        end
      end
    end

    describe "relevant currency" do
      let(:user)   { order.user }
      let(:wallet) { user.wallet }

      describe "match" do
        subject { build(:payment, amount: Money.new(1, wallet.currency), order: order, wallet: wallet) }
        
        it "is valid" do
          expect(subject).to be_valid
        end
      end

      describe "not match" do
        subject { build(:payment, amount: Money.new(1, "RUB")) }

        it "is not valid" do
          expect(wallet.currency).to eq "BTC"
          expect(subject).not_to be_valid
        end
      end
    end
  end
end
