require "rails_helper"

feature 'User as client updates a cart item', %q{
  In order to correct purchase amount.
}, js: true do

  given!(:user)      { create(:user) }
  given!(:cart_item) { create(:cart_item, cart: user.cart, item: create(:item, price: 100), amount: 2) }
  given(:input_field_name) { "order[order_items_attributes][][quantity]" }
  
  background {
    sign_in(user)
  }

  feature "adds item to cart" do
    background { 
      visit cart_path
      find("a.plus").click 
    }

    it "increases the amount" do
      expect(find("td .amount")).to have_field(input_field_name, with: '3')
    end

    it "increases the sum" do
      expect(find("td.sum")).to have_content "300"
    end
    
    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "300"
    end
  end

  feature "removes item from cart" do
    background { 
      visit cart_path
      find("a.minus").click 
    }

    it "decreases the amount" do
      expect(find("td .amount")).to have_field(input_field_name, with: '1')
    end

    it "increases the sum" do
      expect(find("td.sum")).to have_content "100"
    end
    
    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "100"
    end
  end

  feature "stocks" do
    background { 
      cart_item.item.stock.storage_amount = 5
      cart_item.item.stock.save
      visit cart_path
    }

    scenario "displays available amount" do
      expect(cart_item.item.available_amount).to eq 3
      expect(page).to have_content "Available: 3"
    end

    scenario "updates available amount" do
      find("a.plus").click
      expect(page).to have_content "Available: 2"
    end

    scenario "doesn't allow to add an item in cart without available amount" do
      find("a.plus").click
      find("a.plus").click
      find("a.plus").click
      find("a.plus").click
      msg = accept_confirm { }
      expect(msg).to have_content I18n.t("cart_items.errors.not_available")
    end
  end
end