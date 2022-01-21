require "rails_helper"

feature 'User as customer can post order', %q{
  In order to purchase items.
} do

  given(:user)                { create(:user) }
  given!(:cart_item)          { create(:cart_item, cart: user.cart, item: create(:item), amount: 2) }
  given!(:another_cart_item)  { create(:cart_item, cart: user.cart, item: create(:item), amount: 5) }
  
  background { sign_in(user) }

  feature "creates order" do
    scenario "with few items in a cart" do
      visit cart_path
      click_button("Create Order")
      expect(page).to have_content I18n.t("orders.create.message")
    end
  end
end