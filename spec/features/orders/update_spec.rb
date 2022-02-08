require "rails_helper"

feature 'User as staff member can change orders status', %q{
  In order to save info in system and inform the customer.
}, js: true do

  given!(:staff)    { create(:user, type: "Admin") }
  given!(:customer) { create(:user) }
  given!(:order)    { create(:order, :valid, user: customer) }

  shared_examples "guest" do
    scenario "tries to change order status" do
      visit edit_admin_order_path
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to change order status" do
      visit edit_admin_category_path
      expect(page).to have_content I18n.t("pundit.category_policy.new?")
    end
  end

  shared_examples "admin" do
    scenario "updates status" do
      visit edit_admin_category_path
      select "Processing", from: "Status"
      click_button "Update Order"
      expect(page).to have_content "Processing"
      expect(page).to have_content I18n.t("orders.update.message")
    end
  end

  context "being a guest" do
    it_behaves_like "guest"
  end

  context "being a customer" do
    background { sign_in(customer) }
    it_behaves_like "customer"
  end

  context "being an admin" do
    background { sign_in(staff) }
    it_behaves_like "admin"
  end
end