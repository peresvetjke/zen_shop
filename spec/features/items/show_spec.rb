require "rails_helper"

feature 'User as client can view item', %q{
  In order to get familiar with its details and purchase.
}, js: true do

  given(:user)          { create(:user) }
  given(:item)          { create(:item) }
  given(:subscription)  { create(:subscription, item: item, user: user) }

  shared_examples "guest" do
    it "tries to add item to cart" do
      visit items_path
      expect(page).to have_no_button("Add to cart")
      expect(page).to have_content("Please sign in to continue.")
    end
  end

  shared_examples "authenticated" do
    describe "on load" do
      subject { visit item_path(item) }
      
      it "displays title" do
        subject
        expect(page).to have_content(item.title)
      end

      it "displays title" do
        subject
        expect(page).to have_content(item.price)
      end
      
      it "displays description" do
        subject
        expect(page).to have_content(item.description)
      end

      it "displays available amount" do
        subject
        expect(page).to have_content "Available: #{item.available_amount}"
      end

      it "displays rating" do
        subject
        expect(find('#item_info .rating')).to have_content item.rating
      end
    end

    describe "subscriptions", js: true do
      describe "when unsubscribed" do
        describe "with available stock" do
          background { 
            visit item_path(item) 
          }

          it "does not display subscribe link" do
            expect(page).to have_no_button("Subscribe")
          end
        end

        describe "without stock available" do
          background { 
            item.stock.update(storage_amount: 0)
            visit item_path(item) 
          }

          subject { 
            click_button("Subscribe") 
            sleep(0.5)
          }

          it "does not display 'Add to cart' button" do
            expect(page).to have_no_button("Add to cart")
          end

          it "creates subscription" do
            expect{ subject }.to change(Subscription, :count).by(1)
          end

          it "subscribes for a notification about item arrival", js: true do
            subject
            msg = accept_confirm { }
            expect(msg).to have_content I18n.t("items.subscribed")
          end
        end
      end

      describe "when subscribed" do
        background { 
          subscription
          visit item_path(item)
        }

        describe "with available stock" do
          it "does not display subscribe buttons" do
            expect(page).to have_no_button("Subscribe")
            expect(page).to have_no_button("Unsubscribe")
          end
        end

        describe "without stock available" do
          background { 
            item.stock.update(storage_amount: 0)
            visit item_path(item) 
          }

          subject { 
            click_button("Unsubscribe") 
            sleep(0.5)
          }

          it "does not display 'Add to cart' button" do
            expect(page).to have_no_button("Add to cart")
          end

          it "does not display 'Subscribe' button" do
            expect(page).to have_no_button("Subscribe")
          end

          it "deletes subscription" do
            expect{ subject }.to change(Subscription, :count).by(-1)
          end

          it "subscribes for a notification about item arrival", js: true do
            subject
            msg = accept_confirm { }
            expect(msg).to have_content I18n.t("items.unsubscribed")
          end
        end
      end
    end

    describe "reviews" do
      scenario "saves product rating" do
        visit item_path(item)
        find('trix-editor').click.set('My review')
        click_button('Rate product')
        sleep(0.5)
        expect(find('#item_info .rating')).to have_content '5.0'
      end
    end
  end

  describe "being a guest" do
    it_behaves_like "guest"
  end
  
  describe "being authenticated" do
    background { sign_in(user) }
    it_behaves_like "authenticated"
  end
end