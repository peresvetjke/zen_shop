require "rails_helper"

feature 'User as client adds an item to cart', %q{
  In order to perform its purchase.
}, js: true do

  given!(:user) { create(:user) }
  given!(:item) { create(:item) }

  shared_examples "guest" do
    scenario "tries to add item to cart" do
      visit items_path(item)
      expect(page).to have_no_button("Add to cart")
    end
  end

  shared_examples "authenticated" do
    scenario "adds item to cart", js: true do
      visit items_path
      click_button("Add to cart")
      sleep(1)
      within "#add_to_cart_#{item.id}" do
        expect(page).to have_no_button("Add to cart")
        expect(page).to have_field("amount", with: '1', disabled: true)
      end
    end

    # scenario "does not duplicate cart items" do
    #   visit item_path(item)
    #   # fill_in "cart_item[amount]", with: "5"
    #   click_button("Add to cart")
    #   visit item_path(item)
    #   fill_in "cart_item[amount]", with: "5"
    #   click_button("Add to cart")
    #   expect(page).to have_content I18n.t("cart_items.create.message")
    #   expect(page).to have_selector('tr.cart_item', count: 1)
    # end

    feature "stocks" do
      background { 
        item.stock.storage_amount = 2
        item.stock.save
        visit items_path
      }

      scenario "displays available amount" do
        expect(item.available_amount).to eq 2
        expect(page).to have_content "Available: 2"
      end

      scenario "doesn't allow to add an item in cart without available amount" do
        click_button("Add to cart")
        click_button("+")
        click_button("+")
        msg = accept_confirm { }
        expect(msg).to have_content I18n.t("cart_items.errors.not_available")
      end
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