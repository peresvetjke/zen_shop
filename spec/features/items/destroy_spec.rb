require "rails_helper"

feature 'User as an admin can delete category', %q{
  In order to actualize items classification.
}, js: true do

  let!(:category) { create(:category) }

  shared_examples "guest" do
    scenario "tries to delete a category" do
      visit admin_categories_path
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to delete a category" do
      visit admin_categories_path
      expect(page).to have_content I18n.t("pundit.admin/category_policy.destroy?")
    end
  end  

  shared_examples "admin" do
    scenario "deletes a category" do
      visit admin_categories_path
      expect(page).to have_content category.title
      accept_confirm { click_link "Delete" }
      expect(page).to have_no_content category.title
      expect(page).to have_content I18n.t("admin.categories.destroy.message")
    end
  end

  context "being a guest" do
    it_behaves_like "guest"
  end

  context "being a customer" do
    background { sign_in(create(:user)) }
    it_behaves_like "customer"
  end

  context "being an admin" do
    background { sign_in(create(:user, type: "Admin")) }
    it_behaves_like "admin"
  end
end