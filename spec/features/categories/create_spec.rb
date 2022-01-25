require "rails_helper"

feature 'User as admin can create category', %q{
  In order to enhance items classification.
} do

  shared_examples "guest" do
    scenario "tries to create a new category" do
      visit admin_new_category_path
      expect(page).to have_content "You should be logged in as admin"
    end
  end

  shared_examples "customer" do
    scenario "tries to create a new category" do
      visit admin_new_category_path
      expect(page).to have_content "You should be logged in as admin"
    end
  end  

  shared_examples "admin" do
    context "with invalid params" do
      scenario "displays errors" do
        visit admin_new_category_path
        fill_in "title", with: ""
        click_button "Create category"
        expect(page).to have_content "No empty fields!"
      end
    end

    context "with valid params" do
      scenario "creates new category" do
        visit admin_new_category_path
        fill_in "title", with: "New title"
        click_button "Create category"
        expect(page).to have_content "New title"
        expect(page).to have_content t("category.create")
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
    background { sign_in(create(:user, admin: true)) }
    it_behaves_like "admin"
  end
end