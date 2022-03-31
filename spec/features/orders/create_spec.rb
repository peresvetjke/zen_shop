require "rails_helper"

# RSpec.configure do
#   Capybara.javascript_driver = :selenium_chrome
# end

feature 'User as customer can post order', %q{
  In order to purchase items.
}, js: true do

  given(:user)                 { create(:user) }
  given!(:user_cart_item_1)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:user_cart_item_2)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }
  given(:delivery_type_select) { "order[delivery_attributes][delivery_type]" }
  given(:cart_price)           { Money.new(1500_00, "RUB") }
  given(:delivery_cost)        { Money.new(499_94, "RUB") } # https://tariff.pochta.ru/v1/calculate/tariff?json&from=141206&to=101000&sumoc=150000&weight=1500&object=27020&pack=20
  given(:total)                { cart_price + delivery_cost }
  given(:order)                { create(:order, user: user) }

  given(:user_no_money)        { create(:user, :no_money) }
  given!(:user_no_money_ci_1)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:user_no_money_ci_2)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }
  given(:insufficient_sum)     { user_no_money.bitcoin_wallet.calculate_insufficient_btc_amount(money_rub: Money.new(1500_00, "RUB")) }

  feature "deliveries" do
    background { sign_in(user) }

    feature "self-pickup (no delivery)" do
      background { visit cart_path }

      scenario "creates order" do
        select "Self-pickup", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "does not show delivery info" do
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end

      scenario "hides delivery cost after self-pickup chosen" do
        select "Russian Post", from: delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        select "Self-pickup", from: delivery_type_select
        sleep(1)
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end
    end

    feature "russian post delivery" do
      scenario "tries to create order without address" do
        visit cart_path
        select "Russian Post", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content "Must have address"
      end

      scenario "displays suggestions for address input" do
        visit cart_path
        select "Russian Post", from: delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        expect(page).to have_content "ул Покровка, д 15/16"
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        click_button("Checkout")
        sleep(1)
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "displays delivery cost and planned date" do
        visit cart_path
        select "Russian Post", from: delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        expect(page).to have_content "Delivery cost:\n#{delivery_cost} RUB"
        expect(page).to have_content "Total:\n#{total.to_s.split('.').first + '.00'} RUB"
        expect(page).to have_content(/Deadline\:\n\d\d\-\d\d\-\d\d\d\d/)
        click_button("Checkout")
      end

      feature "previous address", js: true do
        feature "with previous order existing" do
          scenario "suggests previous delivery address" do
            order
            visit cart_path
            select "Russian Post", from: delivery_type_select
            sleep(1)
            expect(page).to have_content("Choose previous address?")
            within("#previous_address") do
              page.find("a", text: "Choose").click
            end
            click_button("Checkout")
            sleep(1)
            expect(page).to have_content I18n.t("orders.create.message")
          end
        end
        
        feature "without previous order" do
          scenario "does not display suggested address" do
            visit cart_path
            select "Russian Post", from: delivery_type_select
            sleep(1)
            expect(page).to have_no_content("Choose previous address?")
          end
        end
      end

      feature "default address", js: true do
        feature "with default address existing", js: true do
          given!(:default_address) { create(:default_address, user: user) }
          
          scenario "suggests default delivery address" do
            visit cart_path
            select "Russian Post", from: delivery_type_select
            sleep(1)
            expect(page).to have_content("Choose default address?")
            within("#default_address") do
              find("a", text: "Choose").click
            end
            click_button("Checkout")
            sleep(1)
            expect(page).to have_content I18n.t("orders.create.message")
          end
        end
        
        feature "without previous order" do
          scenario "does not display suggested address" do
            visit cart_path
            select "Russian Post", from: delivery_type_select
            sleep(1)
            expect(page).to have_no_content("Choose default address?")
          end
        end
      end
    end
  end

  feature "payments" do
    feature "with zero wallet balance" do
      scenario "displays insufficient amount" do
        sign_in(user_no_money) 
        visit cart_path
        select "Self-pickup", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content "Please replenish your wallet for #{insufficient_sum}"
      end
    end

    feature "with sufficient wallet balance" do
      scenario "allows to create order " do
        sign_in(user) 
        visit cart_path
        select "Self-pickup", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content I18n.t("orders.create.message")
      end
    end
  end
end