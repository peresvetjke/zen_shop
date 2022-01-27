require "rails_helper"

feature 'User as admin can update a category', %q{
  In order to correct or actualize it.
} do

  let!(:category) { create(:category) }

  subject { visit edit_admin_category_path(category) }

  shared_examples "guest" do
    scenario "tries to edit category" do
      subject
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to edit category" do
      subject
      expect(page).to have_content I18n.t("pundit.category_policy.edit?")
    end
  end  

  shared_examples "admin" do
    context "with invalid params" do
      scenario "displays errors" do
        subject
        fill_in "Title", with: ""
        click_button "Update Category"
        expect(page).to have_content I18n.t("errors.messages.blank")
      end
    end

    context "with valid params" do
      scenario "creates new category" do
        subject
        fill_in "Title", with: "New title"
        click_button "Update Category"
        expect(page).to have_content "New title"
        expect(page).to have_content I18n.t("categories.update.message")
      end
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