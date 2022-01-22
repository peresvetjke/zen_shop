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
      expect(page).to have_content("Your balance: 0.00000000")
      expect(page).to have_content("Your BTC address: #{btc_address}")
    end
  end
end