require 'rails_helper'

RSpec.describe BitcoinWallet, type: :model do
  let!(:user)             { create(:user) }
  let(:master_wallet)     { MoneyTree::Master.new seed_hex: Rails.application.credentials.bitcoin[:master_seed_hex] }
  let(:public_address)    { BitcoinWallet.master_wallet.node_for_path("M/0/#{user.id}").to_bip32 }
  let(:service)           { double(Bitcoin::BalanceRetriever) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:bitcoin_purchases) }
  end

  describe ".update_balances" do
    it "calls BitcoinWallet" do
      expect(Bitcoin::BalanceRetriever).to receive(:new).with([public_address]).and_return(service)
      expect(service).to receive(:call)
      BitcoinWallet.update_balances
    end
  end

  describe "#calculate_insufficient_btc_amount" do
    subject { user.bitcoin_wallet.calculate_insufficient_btc_amount(money_rub: Money.new(10000_00, "RUB")) }

    context "when sufficient" do
      before {
        user.bitcoin_wallet.update(available_btc: Money.new(100000000, "BTC"))
        user.bitcoin_wallet.save
      }

      it "returns zero value" do
        expect(subject).to eq 0
      end
    end

    context "when insufficient" do
      before {
        user.bitcoin_wallet.update(available_btc: Money.new(000000001, "BTC"))
        user.bitcoin_wallet.save
      }

      it "returns difference to replenish" do
        expect(subject).to be > 0
      end
    end
  end
end
