require "rails_helper"

feature 'User as admin can index categories', %q{
  In order to observe its list or choose one for change.
}, js: true do

  let!(:categories) { create_list(:category, 5) }

  shared_examples "guest" do
    scenario "tries to index categories" do
      visit admin_categories_path
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to index categories" do
      visit admin_categories_path
      expect(page).to have_content I18n.t("pundit.category_policy.index?")
    end
  end  

  shared_examples "admin" do
    scenario "displays categories" do
      visit admin_categories_path
      categories.each { |c| expect(page).to have_content(c.title) }
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