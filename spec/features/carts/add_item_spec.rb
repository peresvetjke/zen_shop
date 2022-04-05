require "rails_helper"

feature 'User as client adds an item to cart', %q{
  In order to perform its purchase.
}, js: true do

  given!(:user_1) { create(:user) }
  given!(:user_2) { create(:user) }
  given!(:user_3) { create(:user) }
  given!(:item)   { create(:item) }
  
  shared_examples "guest" do
    it "tries to add item to cart" do
      Capybara.using_session('guest') do
        visit items_path(item)
        expect(page).to have_no_button("Add to cart")
      end
    end
  end

  shared_examples "authenticated" do
    it "adds item to cart" do
      Capybara.using_session('user_1') do
        visit items_path
        click_button("Add to cart")
        within ".item[data-item-id='#{item.id}']" do
          expect(page).to have_no_button("Add to cart")
          expect(page).to have_field("amount", with: '1', disabled: true)
        end
      end
    end

    it "does not relate to other user sessions" do
      Capybara.using_session('user_2') do
        visit items_path
      end

      Capybara.using_session('user_3') do
        visit item_path(item)
      end

      Capybara.using_session('user_1') do
        visit items_path
        click_button("Add to cart")
      end

      Capybara.using_session('user_2') do
        sleep(0.5)
        expect(page).to have_button("Add to cart")
      end

      Capybara.using_session('user_3') do
        sleep(0.5)
        expect(page).to have_button("Add to cart")
      end
    end

    describe "stocks" do
      background { 
        item.stock.storage_amount = 2
        item.stock.save
        Capybara.using_session('user_1') do
          visit items_path
        end
      }

      it "displays available amount" do
        expect(item.available_amount).to eq 2
        Capybara.using_session('user_1') do
          expect(page).to have_content "Available: 2"
        end
      end

      it "doesn't allow to add an item in cart without available amount" do
        Capybara.using_session('user_1') do
          click_button("Add to cart")
          click_button("+")
          click_button("+")
          msg = accept_confirm { }
          expect(msg).to have_content I18n.t("cart_items.errors.not_available")
        end
      end
    end
  end

  describe "being a guest" do
    it_behaves_like "guest"
  end
  
  describe "being authenticated" do
    background do
      Capybara.using_session('user_1') { sign_in(user_1) }
      Capybara.using_session('user_2') { sign_in(user_2) }
      Capybara.using_session('user_3') { sign_in(user_3) }
    end

    it_behaves_like "authenticated"
  end
end