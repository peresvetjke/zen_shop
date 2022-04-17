require 'rails_helper'

RSpec.describe BitcoinWallet, type: :model do
  let!(:user)             { create(:user) }
  let(:master_wallet)     { MoneyTree::Master.new seed_hex: Rails.application.credentials.bitcoin[:master_seed_hex] }
  let(:public_address)    { BitcoinWallet.master_wallet.node_for_path("M/0/#{user.id}").to_bip32 }
  let(:service)           { double(Bitcoin::BalanceRetriever) }

  describe ".update_balances" do
    it "calls BitcoinWallet" do
      expect(Bitcoin::BalanceRetriever).to receive(:new).with([public_address]).and_return(service)
      expect(service).to receive(:call)
      BitcoinWallet.update_balances
    end
  end
end
