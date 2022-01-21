require "rails_helper"

feature 'User as client deletes a cart item', %q{
  In order to decline its purchase.
}, js: true do

  given!(:user)              { create(:user) }
  given!(:cart_item)         { create(:cart_item, cart: user.cart, item: create(:item, price: 100), amount: 2) }

  feature "removes cart item" do
    background { 
      sign_in(user)
      visit cart_path
    }

    subject {
      find(".remove_item").click
      page.accept_alert
    }

    it "deletes cart item" do
      expect(page).to have_content(cart_item.item.title)
      subject
      expect(page).to have_no_content(cart_item.item.title)
    end

    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "200"
      subject
      expect(find("#total_sum")).to have_no_content "200"
    end
  end
end