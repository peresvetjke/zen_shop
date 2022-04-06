require "rails_helper"

feature 'User as client deletes a cart item', %q{
  In order to decline its purchase.
}, js: true do

  given!(:user)        { create(:user) }
  given!(:cart_item_1) { create(:cart_item, cart: user.cart, item: create(:item, price: 1000, weight_gross_gr: 1000), amount: 1) }
  given!(:cart_item_2) { create(:cart_item, cart: user.cart, item: create(:item, price: 100, weight_gross_gr: 20), amount: 5) }

  feature "removes cart item" do
    background { 
      sign_in(user)
      visit cart_path
    }

    subject {
      within("[data-cartitems-id-value='#{cart_item_2.id}']") do
        find(".delete").click
      end
    }

    it "deletes cart item" do
      expect(page).to have_content(cart_item_2.item.title)
      subject
      expect(page).to have_no_content(cart_item_2.item.title)
    end

    it "decreases the total price" do
      expect(find("#total_price")).to have_content "1500"
      subject
      expect(find("#total_price")).to have_content "1000"
    end

    it "decreases the total weight" do
      expect(find("#total_weight")).to have_content "1100"
      subject
      expect(find("#total_weight")).to have_content "1000"
    end
  end
end