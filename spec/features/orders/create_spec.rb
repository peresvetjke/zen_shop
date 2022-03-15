require "rails_helper"

feature 'User as customer can post order', %q{
  In order to purchase items.
}, js: true do

  given(:user)                 { create(:user) }
  given!(:user_cart_item_1)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:user_cart_item_2)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }
  given(:delivery_type_select) { "order[delivery_attributes][delivery_type]" }
  given(:delivery_cost)        { Money.new(499_94, "RUB") } # https://tariff.pochta.ru/v1/calculate/tariff?json&from=141206&to=101000&sumoc=150000&weight=1500&object=27020&pack=20

  given(:user_no_money)        { create(:user, :no_money) }
  given!(:user_no_money_ci_1)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:user_no_money_ci_2)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }
  given(:insufficient_sum)     { user_no_money.bitcoin_wallet.calculate_insufficient_btc_amount(money_rub: Money.new(1500_00, "RUB")) }

  feature "deliveries" do
    background { 
      sign_in(user) 
      visit cart_path
    }

    feature "self-pickup (no delivery)" do
      scenario "creates order" do
        select "Self-pickup", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "hides delivery cost when self-pickup chosen" do
        select "Russian Post", from: delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        expect(page).to have_content "ул Покровка, д 15/16"
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        select "Self-pickup", from: delivery_type_select
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end
    end

    feature "russian post delivery" do
      scenario "tries to create order without address", js: true do
        select "Russian Post", from: delivery_type_select
        click_button("Checkout")
        expect(page).to have_content "Must have address"
      end

      scenario "displays suggestions for address input", js: true do
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
        select "Russian Post", from: delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        save_and_open_page
        expect(page).to have_content "Delivery cost:\n#{delivery_cost} RUB"
        expect(page).to have_content(/Deadline\:\n\d\d\-\d\d\-\d\d\d\d/)
        click_button("Checkout")
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