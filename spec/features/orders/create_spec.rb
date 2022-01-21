require "rails_helper"

feature 'User as customer can post order', %q{
  In order to purchase items.
}, js: true do

  given(:user)                 { create(:user) }
  given!(:cart_item)           { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:another_cart_item)   { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }
  given(:order_sum)            { }
  given(:delivery_type_select) { "order[delivery_attributes][delivery_type]" }
  given(:delivery_cost)        { Money.new(499_94, "RUB") } # https://tariff.pochta.ru/v1/calculate/tariff?json&from=141206&to=101000&sumoc=150000&weight=1500&object=27020&pack=20

  background { 
    sign_in(user) 
    visit cart_path
  }

  feature "self-pickup (no delivery)" do
    scenario "creates order" do
      select "Self-pickup", from: delivery_type_select
      click_button("Create Order")
      expect(page).to have_content I18n.t("orders.create.message")
    end

    scenario "hides delivery cost when self-pickup chosen" do
      select "Russian Post", from: delivery_type_select
      fill_in 'address', with: "Покровка 16"
      expect(page).to have_content "ул Покровка, д 15/16"
      page.first("span.suggestions-nowrap", text: "д 15/16").click
      sleep(1)
      select "Self-pickup", from: delivery_type_select
      expect(page).to have_no_content "Address:"
      expect(page).to have_no_content "Delivery cost:"
      expect(page).to have_no_content "Deadline:"
    end
  end

  feature "russian post delivery" do
    scenario "tries to create order without address" do
      select "Russian Post", from: delivery_type_select
      click_button("Create Order")
      expect(page).to have_content "Must have address"
    end

    scenario "displays suggestions for address input" do
      select "Russian Post", from: delivery_type_select
      fill_in 'address', with: "Покровка 16"
      expect(page).to have_content "ул Покровка, д 15/16"
      page.first("span.suggestions-nowrap", text: "д 15/16").click
      sleep(1)
      click_button("Create Order")
      expect(page).to have_content I18n.t("orders.create.message")
    end

    scenario "displays delivery cost and planned date" do
      select "Russian Post", from: delivery_type_select
      fill_in 'address', with: "Покровка 16"
      page.first("span.suggestions-nowrap", text: "д 15/16").click
      sleep(1)
      expect(page).to have_content "Delivery cost: #{delivery_cost} RUB"
      expect(page).to have_content(/Deadline\: \d\d\-\d\d\-\d\d\d\d/)
      click_button("Create Order")
    end
  end
end