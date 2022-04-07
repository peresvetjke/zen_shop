require "rails_helper"
# require "head_helper"

feature 'User as client can index all items list', %q{
  In order to find the one he interested in
}, js: true do

  given(:user)              { create(:user) }
  given!(:category_1)       { create(:category) }
  given!(:category_2)       { create(:category) }
  given(:category_1_items)  { create_list(:item, 5, category: category_1) }
  given(:category_2_items)  { create_list(:item, 5, category: category_2) }
  given(:item)              { category_1_items.first }
  given(:category)          { Category.first }

  shared_examples "guest" do
    it "tries to add item to cart" do
      visit items_path
      expect(page).to have_no_button("Add to cart")
      expect(page).to have_content("Please sign in to continue.")
    end
  end

  shared_examples "authenticated" do
    describe "without items" do
      it "indexes no items" do
        visit items_path
        expect(page).to have_text("No items at the moment.")
      end
    end

    describe "with items" do
      background {
        category_1_items
        category_2_items
        visit items_path
      }

      it "displays all the items" do
        expect(page.all('.item').count).to eq Item.all.count
        expect(Item.all.all?{ |i| page.has_content?(i.title) })
      end

      it "displays items of selected category" do
        visit category_items_path(category)
        expect(page.all('.item').count).to eq 5
        expect(category.items.all?{ |i| page.has_content?(i.title) })
      end

      it "displays current availability" do
        expect(find("##{dom_id(item)}")).to have_content "Available: #{item.available_amount} pc"
      end
    end

    describe "cart item" do
      given(:cart_item) { create(:cart_item, cart: user.cart, item: item, amount: 1) }

      background {
        category_1_items
        category_2_items
      }

      describe "on create" do
        background {
          visit items_path
        }

        subject {
          within "##{dom_id(item)}" do
            click_button("Add to cart")
          end
          sleep(0.5)
        }

        it "creates cart item" do
          expect{subject}.to change(CartItem, :count).by(1)
        end

        it "displays +/- panel" do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_no_button("Add to cart")
            expect(page).to have_field("amount", with: '1', disabled: true)
          end
        end

        it "decreases availability" do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_content "Available: #{item.reload.available_amount} pc"
          end
        end
      end

      describe "on load" do
        background { 
          cart_item
          visit items_path
        }

        it "displays current amount" do  
          within "##{dom_id(item)}" do
            expect(page).to have_field('amount', with: cart_item.amount, disabled: true)
          end
        end

        it "displays availability" do
          within "##{dom_id(item)}" do
            expect(page).to have_content "Available: #{item.available_amount} pc"
          end
        end
      end

      describe "on update" do
        background { 
          cart_item
          visit items_path
        }

        subject {
          within "##{dom_id(cart_item.item)}" do
            click_button('+')
          end
          sleep(0.5)
        }

        it "updates amount" do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_field('amount', with: cart_item.reload.amount, disabled: true)
          end
        end

        it "updates availability" do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_content "Available: #{item.reload.available_amount} pc"
          end
        end
      end

      describe "on delete" do
        background { 
          cart_item
          visit items_path
        }

        subject {
          within "##{dom_id(cart_item.item)}" do
            click_button('-')
          end
          sleep(0.5)
        }

        it "removes cart item" do
          expect{subject}.to change(CartItem, :count).by(-1)
        end

        it "updates availability", js: true do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_content "Available: #{item.reload.available_amount} pc"
          end
        end

        it "displays 'Add to cart' button" do
          subject
          within "##{dom_id(item)}" do
            expect(page).to have_button "Add to cart"
          end
        end
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