require "rails_helper"

feature 'User as client adds an item to cart', %q{
  In order to perform its purchase.
} do

  given!(:user) { create(:user) }
  given!(:item) { create(:item) }

  shared_examples "guest" do
    scenario "tries to add item to cart" do
      visit item_path(item)
      expect(page).to have_no_button(".add_to_cart")
    end
  end

  shared_examples "authenticated" do
    scenario "adds item to cart" do
      visit item_path(item)
      fill_in "cart_item[amount]", with: "5"
      click_button("Add to cart")
      expect(page).to have_content I18n.t("cart_items.create.message")
    end
  end

  feature "being a guest" do
    it_behaves_like "guest"
  end
  
  feature "being authenticated" do
    background { sign_in(user) }
    it_behaves_like "authenticated"
  end
end