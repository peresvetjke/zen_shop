require "rails_helper"

feature 'User as admin can view a category', %q{
  In order to check its details.
} do

  let!(:category) { create(:category) }

  subject { visit admin_category_path(category) }

  shared_examples "guest" do
    scenario "tries to view category" do
      subject
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to view categories" do
      subject
      expect(page).to have_content I18n.t("pundit.category_policy.show?")
    end
  end  

  shared_examples "admin" do
    scenario "displays categories" do
      subject
      expect(page).to have_content(category.title)
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