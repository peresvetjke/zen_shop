require "rails_helper"
# require "head_helper"

feature 'User as customer can post order', %q{
  In order to purchase items.
}, js: true do

  given(:user)                 { create(:user) }
  given!(:user_cart_item_1)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(100_00, "USD")), quantity: 2) }
  given!(:user_cart_item_2)    { create(:cart_item, cart: user.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(10_00, "USD")), quantity: 5) }
  given(:order_delivery_type_select) { "order[delivery_type]" }
  given(:delivery_type_select) { "order[delivery_attributes][type]" }
  given(:user_no_money)        { create(:user, :no_money) }
  given!(:user_no_money_ci_1)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), quantity: 2) }
  given!(:user_no_money_ci_2)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), quantity: 5) }

  background { 
    sign_in(user)
    visit cart_path
  }

  describe "cart item", js: true do
    describe "initial load", js: true do
      it "displays item title" do
        expect(page).to have_content(user_cart_item_1.item.title)
      end

      it "displays item sum" do
        expect(find("##{dom_id(user_cart_item_1)} .sum")).to have_content(user_cart_item_1.quantity * user_cart_item_1.item.price)
      end

      it "displays item available amount" do
        expect(find("##{dom_id(user_cart_item_1)} .available_amount")).to have_content(user_cart_item_1.item.stock.storage_amount)
      end

      it "displays total weight" do
        expect(find("#total_weight")).to have_content(user.cart.total_weight)
      end

      it "displays total price" do
        total_price = find("#total_price").text
        expect(total_price).to match(/\d\.\d{8}/)
        expect(total_price.to_f).to be > 0
      end

      it "displays total sum" do
        total_sum = find("#total_sum").text
        expect(total_sum).to match(/\d\.\d{8}/)
        expect(total_sum.to_f).to be > 0
      end
    end

    describe "update", js: true do
      subject {
        within "##{dom_id(user_cart_item_1)}" do
          select "5", from: "quantity"
        end
        sleep(0.5)
      }

      it "changes item sum" do
        item_sum = find("##{dom_id(user_cart_item_1)} .sum").text
        subject
        expect(find("##{dom_id(user_cart_item_1)} .sum").text).not_to eq item_sum
      end
      
      it "changes item available amount" do
        subject
        expect(find("##{dom_id(user_cart_item_1)} .available_amount")).to have_content(user_cart_item_1.item.stock.reload.storage_amount)
      end

      it "does not allow to add an item in cart without available amount" do
        user_cart_item_1.item.stock.storage_amount = 2
        user_cart_item_1.item.stock.save
        subject
        msg = accept_confirm { }
        expect(msg).to have_content I18n.t("cart_items.errors.not_available")
      end

      it "changes total weight" do
        expect(find("#total_weight")).to have_content(user.cart.reload.total_weight)
      end

      it "changes total price" do
        total_price = find("#total_price").text
        subject
        expect(find("#total_price").text).not_to eq total_price
      end

      it "changes total sum" do
        total_sum = find("#total_sum").text
        subject
        expect(find("#total_sum").text).not_to eq total_sum
      end
    end

    describe "delete" do
      subject {
        within "##{dom_id(user_cart_item_1)}" do
          find("a.delete").click 
        end
        sleep(0.5)
      }

      it "removes item" do
        expect(page).to have_content(user_cart_item_1.item.title)
        subject
        expect(page).to have_no_content(user_cart_item_1.item.title)
      end

      it "changes total weight" do
        subject
        expect(find("#total_weight")).to have_content(user.cart.reload.total_weight)
      end

      it "changes total price" do
        total_price = find("#total_price").text
        subject
        expect(find("#total_price").text).not_to eq total_price
      end

      it "changes total" do
        total_sum = find("#total_sum").text
        subject
        expect(find("#total_sum").text).not_to eq total_sum
      end
    end
  end

  feature "deliveries" do
    feature "self-pickup (no delivery)" do
      subject {
        select "Self-pickup", from: order_delivery_type_select
        sleep(0.5)
      }

      scenario "displays default select" do
        expect(page).to have_content "Self-pickup" 
      end

      scenario "creates order" do
        subject
        find("a", text: "Checkout").click
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "does not show delivery info" do
        subject
        expect(page).to have_no_content "RussianPostDelivery"
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end

      scenario "hides delivery cost after self-pickup chosen" do
        select "Delivery", from: order_delivery_type_select
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        subject
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end
    end

    feature "russian post delivery" do
      subject { 
        select "Delivery", from: order_delivery_type_select 
      }

      scenario "does not allow to create order without address" do
        subject
        find("a", text: "Checkout").click
        expect(page).to have_content "Address can't be blank"
      end

      scenario "displays dada suggestions for address input" do
        subject
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        expect(page).to have_content "ул Покровка, д 15/16"
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        find("a", text: "Checkout").click
        sleep(1)
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "displays delivery cost and planned date", js: true do
        subject
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        delivery_cost = find("#delivery_cost").text
        expect(delivery_cost.to_f).to be > 0
        expect(delivery_cost).to match(/\d\.\d{8}/)
        total_sum = find("#total_sum").text
        expect(total_sum.to_f).to be > 0
        expect(total_sum).to match(/\d\.\d{8}/)
        find("a", text: "Checkout").click
      end

      feature "previous address suggestion", js: true do
        feature "with previous order existing" do
          given!(:order)       { create(:order, delivery_type: 1, user: user) }
          given!(:cart_item_1) { create(:cart_item, cart: user.cart) }
          given!(:cart_item_2) { create(:cart_item, cart: user.cart) }

          scenario "suggests previous delivery address" do
            visit cart_path
            select "Delivery", from: order_delivery_type_select
            sleep(1)

            expect(page).to have_content("Choose previous address?")
            within("#previous_address") do
              page.find("a", text: "Choose").click
            end
            find("a", text: "Checkout").click
            sleep(1)
            expect(page).to have_content I18n.t("orders.create.message")
          end
        end
        
        feature "without previous order" do
          given!(:cart_item_1) { create(:cart_item, cart: user.cart) }
          given!(:cart_item_2) { create(:cart_item, cart: user.cart) }

          scenario "does not display suggested address" do
            visit cart_path
            select "Delivery", from: order_delivery_type_select
            sleep(1)
        
            expect(page).to have_no_content("Choose previous address?")
          end
        end
      end

      describe "default address suggestion", js: true do
        describe "with default address existing", js: true do
          given(:default_address) { create(:default_address, user: user) }
          
          background { 
            default_address 
            visit cart_path
            select "Delivery", from: order_delivery_type_select
            sleep(0.5)
          }

          subject {
            within("#default_address") do
              find("a", text: "Choose").click
            end
            sleep(0.5)
          }

          it "suggests default delivery address" do
            expect(page).to have_content("Choose default address?")
          end

          it "displays chosen default address", js: true do
            subject
            expect(find("input#country").value).to eq default_address.address.country
            expect(find("input#postal_code").value).to eq default_address.address.postal_code
            expect(find("input#region_with_type").value).to eq default_address.address.region_with_type
            expect(find("input#city_with_type").value).to eq default_address.address.city_with_type
            expect(find("input#street_with_type").value).to eq default_address.address.street_with_type
            expect(find("input#house").value).to eq default_address.address.house
            expect(find("input#flat").value).to eq default_address.address.flat
          end
          
          it "allows to create order with default address" do
            subject
            find("a", text: "Checkout").click
            expect(page).to have_content I18n.t("orders.create.message")
          end
        end
        
        describe "without previous order" do
          background { 
            visit cart_path
            select "Delivery", from: order_delivery_type_select
            sleep(0.5)
          }

          it "does not display suggested address" do
            expect(page).to have_no_content("Choose default address?")
          end
        end
      end
    end
  end

  feature "payments" do
    subject {
      visit cart_path
      select "Self-pickup", from: order_delivery_type_select
      find("a", text: "Checkout").click
    }

    feature "with zero wallet balance", js: true do
      background {
        sign_out
        sign_in(user_no_money) 
      }

      scenario "displays insufficient amount" do
        subject
        expect(page).to have_content "Not sufficient funds. Please replenish you wallet."
      end
    end

    feature "with sufficient wallet balance" do
      scenario "allows to create order " do
        subject
        expect(page).to have_content I18n.t("orders.create.message")
      end
    end
  end
end