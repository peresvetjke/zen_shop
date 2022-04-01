require "rails_helper"

feature 'User as admin can create item', %q{
  In order to enhance items list.
}, js: true do

  let!(:category) { create(:category) }

  shared_examples "guest" do
    scenario "tries to create a new item" do
      visit admin_items_path
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to create a new item" do
      visit admin_items_path
      expect(page).to have_content I18n.t("pundit.admin/item_policy.new?")
    end
  end

  shared_examples "admin", js: true do
    context "with invalid params" do
      scenario "displays errors" do
        visit admin_items_path
        select "#{category.title}", from: "item[category_id]"
        fill_in "item_title", with: ""
        fill_in "item[weight_gross_gr]", with: 150
        click_button "Save"
        expect(page).to have_content I18n.t("errors.messages.blank")
      end
    end

    context "with valid params" do
      scenario "creates new category" do
        visit admin_items_path
        select "#{category.title}", from: "item[category_id]"
        fill_in "item_title", with: "New title"
        fill_in "item[weight_gross_gr]", with: 150
        click_button "Save"
        expect(page).to have_content "New title"
        expect(page).to have_content I18n.t("admin.items.create.message")
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