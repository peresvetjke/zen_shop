require "rails_helper"

feature 'User as customer can check his account info', %q{
  In order to check or update its details.
} do

  given(:user)        { create(:user) }
  given(:btc_address) { user.wallet.public_address }

  subject { visit account_path }

  shared_examples "guest" do
    describe "show account" do
      it "deny access" do
        subject
        expect(page).to have_content I18n.t("devise.failure.unauthenticated")
      end
    end
  end

  shared_examples "customer" do
    describe "show account" do
      it "displays account" do
        subject
        expect(page).to have_content("Your balance:\n#{user.wallet.balance}")
        expect(page).to have_field('btc_wallet_address', with: btc_address)
      end
    end
  end

  context "being a guest" do
    it_behaves_like "guest"
  end

  context "being a customer" do
    background { sign_in(user) }
    it_behaves_like "customer"
  end
end