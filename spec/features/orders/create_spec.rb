require "rails_helper"

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
  

  given(:user_no_money)        { create(:user, :no_money) }
  given!(:user_no_money_ci_1)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 250, price: Money.new(250_00, "RUB")), amount: 2) }
  given!(:user_no_money_ci_2)  { create(:cart_item, cart: user_no_money.cart, item: create(:item, weight_gross_gr: 200, price: Money.new(200_00, "RUB")), amount: 5) }

  background { 
    sign_in(user)
    visit cart_path
  }

  describe "cart item", js: true do
    describe "initial load", js: true do
      # background { visit cart_path }

      it "displays item title" do
        expect(page).to have_content(user_cart_item_1.item.title)
      end

      it "displays item sum" do
        expect(find("##{dom_id(user_cart_item_1)} .sum")).to have_content('500')
      end

      it "displays item available amount" do
        expect(find("##{dom_id(user_cart_item_1)} .available_amount")).to have_content(user_cart_item_1.item.available_amount)
      end

      it "displays total weight" do
        expect(find("#total_weight")).to have_content(user.cart.total_weight)
      end

      it "displays total price" do
        expect(find("#total_price")).to have_content(user.cart.total_sum)
      end

      it "displays total sum" do
        expect(find("#total_sum")).to have_content(user.cart.total_sum)
      end
    end

    describe "update", js: true do
      subject {
        within "##{dom_id(user_cart_item_1)}" do
          select "5", from: "amount"
        end
      }

      it "changes item sum" do
        subject
        expect(find("##{dom_id(user_cart_item_1)} .sum")).to have_content('1250')
      end
      
      it "changes item available amount" do
        subject
        expect(find("##{dom_id(user_cart_item_1)} .available_amount")).to have_content(user_cart_item_1.item.reload.available_amount)
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
        expect(find("#total_price")).to have_content(user.cart.reload.total_sum)
      end

      it "changes total sum" do
        expect(find("#total_sum")).to have_content(user.cart.reload.total_sum)
      end
    end

    describe "delete" do
      subject {
        # visit cart_path
        
        within "##{dom_id(user_cart_item_1)}" do
          find("a.delete").click 
        end
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
        subject
        expect(find("#total_price")).to have_content(user.cart.reload.total_sum)
      end

      it "changes total" do
        subject
        expect(find("#total_sum")).to have_content(user.cart.reload.total_sum)
      end
    end
  end

  feature "deliveries" do
    feature "self-pickup (no delivery)" do
      subject {
        select "Self-pickup", from: delivery_type_select
      }

      scenario "creates order" do
        subject
        click_button("Checkout")
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "does not show delivery info" do
        subject
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
        subject
        expect(page).to have_no_content "Address:"
        expect(page).to have_no_content "Delivery cost:"
        expect(page).to have_no_content "Deadline:"
      end
    end

    feature "russian post delivery" do
      subject { 
        select "Russian Post", from: delivery_type_select 
      }

      scenario "does not allow to create order without address" do
        subject
        click_button("Checkout")
        expect(page).to have_content "Must have address"
      end

      scenario "displays dada suggestions for address input" do
        subject
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        expect(page).to have_content "ул Покровка, д 15/16"
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        click_button("Checkout")
        sleep(1)
        expect(page).to have_content I18n.t("orders.create.message")
      end

      scenario "displays delivery cost and planned date", js: true do
        subject
        fill_in 'address', with: "Покровка 16"
        sleep(1)
        page.first("span.suggestions-nowrap", text: "д 15/16").click
        sleep(1)
        expect(page).to have_content "Delivery cost:\n#{delivery_cost} RUB"
        expect(page).to have_content "Total:\n#{total.to_s} RUB"
        expect(page).to have_content(/Deadline\:\n\d\d\-\d\d\-\d\d\d\d/)
        click_button("Checkout")
      end

      feature "previous address suggestion", js: true do
        given(:order)       { create(:order, user: user) }
        given(:cart_item_1) { create(:cart_item, cart: user.cart) }
        given(:cart_item_2) { create(:cart_item, cart: user.cart) }

        subject {
          visit cart_path
          select "Russian Post", from: delivery_type_select
          sleep(1)
        }

        feature "with previous order existing" do
          background {
            order
            cart_item_1
            cart_item_2
          }

          scenario "suggests previous delivery address" do
            subject
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
          background {
            cart_item_1
            cart_item_2
          }

          scenario "does not display suggested address" do
            subject
            expect(page).to have_no_content("Choose previous address?")
          end
        end
      end

      feature "default address suggestion", js: true do
        feature "with default address existing", js: true do
          given(:default_address) { create(:default_address, user: user) }
          
          subject {
            visit cart_path
            select "Russian Post", from: delivery_type_select
            sleep(1)
          }

          scenario "suggests default delivery address" do
            default_address
            subject
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
            subject
            expect(page).to have_no_content("Choose default address?")
          end
        end
      end
    end
  end

  feature "payments" do
    subject {
      visit cart_path
      select "Self-pickup", from: delivery_type_select
      click_button("Checkout")
    }

    feature "with zero wallet balance" do
      scenario "displays insufficient amount" do
        insufficient_sum = user_no_money.bitcoin_wallet.calculate_insufficient_btc_amount(money_rub: Money.new(1500_00, "RUB"))
        
        Capybara.using_session('no_money') do
          sign_in(user_no_money) 
          subject
          expect(page).to have_content "Please replenish your wallet for #{insufficient_sum}"
        end
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