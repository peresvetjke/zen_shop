require "rails_helper"

feature 'User as client updates a cart item', %q{
  In order to correct purchase amount.
}, js: true do

  # RSpec.configure do |config|
  #   Capybara.javascript_driver = :selenium_chrome
  # end

  given!(:user)        { create(:user) }
  given!(:cart_item_1) { create(:cart_item, cart: user.cart, item: create(:item, price: 100), amount: 2) }
  given!(:cart_item_2) { create(:cart_item, cart: user.cart, item: create(:item, price: 200), amount: 5) }

  background {
    sign_in(user)
  }

  feature "updates item amount and totals" do
    background { 
      visit cart_path
      within "#cart_item_#{cart_item_1.id}" do
        select "5", from: "amount"
      end
    }

    it "increases the amount" do
      within "#cart_item_#{cart_item_1.id}" do
        expect(find("#amount")).to have_content('5')
      end
    end

    it "increases the sum" do
      within "#cart_item_#{cart_item_1.id}" do
        expect(find("span.sum")).to have_content('500')
      end
    end
    
    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "1500"
    end
  end

  feature "removes item from cart" do
    background {
      visit cart_path
      expect(page).to have_content(cart_item_1.item.title)
      within "#cart_item_#{cart_item_1.id}" do
        find("a.delete").click 
      end
    }

    it "removes item" do
      expect(page).to have_no_content(cart_item_1.item.title)
    end

    it "decreases the total amount" do
      expect(find("#total_sum")).to have_content "1000"
    end
  end

  feature "stocks" do
    background { 
      cart_item_1.item.stock.storage_amount = 2
      cart_item_1.item.stock.save
      visit cart_path
    }

    scenario "displays available amount" do
      expect(cart_item_1.item.available_amount).to eq 0
      within "#cart_item_#{cart_item_1.id}" do
        expect(page).to have_content "Available: 0"
      end
      
    end

    scenario "updates available amount" do
      within "#cart_item_#{cart_item_1.id}" do
        expect(page).to have_content "Available: 0"
        select "1", from: "amount"
      end
      expect(page).to have_content "Available: 1"
    end

    scenario "doesn't allow to add an item in cart without available amount" do
      within "#cart_item_#{cart_item_1.id}" do
        select "5", from: "amount"
      end
      msg = accept_confirm { }
      expect(msg).to have_content I18n.t("cart_items.errors.not_available")
    end
  end
end