require "rails_helper"

feature 'User as customer can check his account info', %q{
  In order to check or update its details.
} do

  given(:user)        { create(:user) }
  given(:btc_address) { user.bitcoin_wallet.public_address }
  
  background { 
    sign_in(user) 
    visit account_path
  }

  feature "bitcoin wallet" do
    it "displays user's personal btc address" do
      expect(page).to have_content("Your balance:\n#{user.bitcoin_wallet.available_btc}")
      expect(page).to have_field('btc_wallet_address', with: btc_address)
    end
  end
end