require "rails_helper"

feature 'User as client add an item to cart', %q{
  In order to get prepared for checkout.
} do

  given!(:user) { create(:user) }
  
  shared_examples "guest" do
    feature "tries to view cart" do
      it "renders no cart link" do
        visit items_path
        expect(page).to have_no_link("#cart")
      end
    end
  end

  shared_examples "authenticated" do
    feature "views cart" do
      feature "with no items" do
        it "renders empty cart" do
          visit items_path
          find("#cart").click
          expect(page).to have_content("No items in cart yet.")
        end
      end

      feature "with few items" do
        given!(:cart_item)          { create(:cart_item, cart: user.cart, item: create(:item), amount: 2) }
        given!(:another_cart_item)  { create(:cart_item, cart: user.cart, item: create(:item), amount: 5) }

        background { visit cart_path }
        
        it "indexes items list" do
          expect(page).to have_content(cart_item.item.title)
          expect(page).to have_content(another_cart_item.item.title)
        end
        
        it "renders total amount" do
          expect(page).to have_content(user.cart.total_sum)
        end
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