require 'pry'
require "rails_helper"

RSpec.configure do
  Capybara.javascript_driver = :selenium_chrome
end

feature 'User as client can view item', %q{
  In order to get familiar with its details and purchase.
} do

  given(:user)          { create(:user) }
  given(:item)          { create(:item) }
  given(:subscription)  { create(:subscription, item: item, user: user) }

  background { 
    sign_in(user)
    visit item_path(item) 
  }

  scenario "displays item" do
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.price)
    expect(page).to have_content(item.description)
  end

  feature "stocks" do
    scenario "displays available amount" do
      expect(item.available_amount).to eq 100
      expect(page).to have_content "Available: 100"
    end
  end

  feature "subscriptions", js: true do
    feature "when unsubscribed" do
      feature "with available stock" do
        scenario "does not display subscribe link" do
          expect(page).to have_no_link("Subscribe")
        end
      end

      feature "no stock available" do
        background { 
          item.stock.update(storage_amount: 0)
          visit item_path(item) 
        }

        scenario "subscribes for a notification about item arrival", js: true do
          expect(page).to have_no_button("Add to cart")
          binding.pry
          save_and_open_page
          click_link("Subscribe")
          msg = accept_confirm { }
          expect(msg).to have_content I18n.t("items.subscribed")
        end
      end
    end

    feature "when subscribed" do
      background { subscription }

      feature "with available stock" do
        feature "unsubscribes from notifications" do
          scenario "unsubscribes from notifications" do
            visit item_path(item)
            expect(page).to have_no_button("Subscribe")
            click_link("Unsubscribe")
            msg = accept_confirm { }
            expect(msg).to have_content I18n.t("items.unsubscribed")
          end
        end
      end
      
      feature "no stock available" do
        background { item.stock.update(storage_amount: 0) }

        feature "unsubscribes from notifications" do
          scenario "unsubscribes from notifications" do
            visit item_path(item)
            expect(page).to have_no_button("Subscribe")
            click_link("Unsubscribe")
            msg = accept_confirm { }
            expect(msg).to have_content I18n.t("items.unsubscribed")
          end
        end
      end
    end
  end
end