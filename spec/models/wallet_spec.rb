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
end
