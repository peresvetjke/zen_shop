require "rails_helper"

feature 'User as client updates a cart item', %q{
  In order to correct purchase amount.
}, js: true do

  given!(:user)      { create(:user) }
  given!(:cart_item) { create(:cart_item, cart: user.cart, item: create(:item, price: 100), amount: 2) }
  given(:input_field_name) { "order[order_items_attributes][][quantity]" }
  
  background {
    sign_in(user)
    visit cart_path
  }

  feature "adds item to cart" do
    background { find("a.plus").click }

    it "increases the amount" do
      expect(find("td.amount")).to have_field(input_field_name, with: '3')
    end

    it "increases the sum" do
      expect(find("td.sum")).to have_content "300"
    end
    
    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "300"
    end
  end

  feature "removes item from cart" do
    background { find("a.minus").click }

    it "decreases the amount" do
      expect(find("td.amount")).to have_field(input_field_name, with: '1')
    end

    it "increases the sum" do
      expect(find("td.sum")).to have_content "100"
    end
    
    it "increases the total amount" do
      expect(find("#total_sum")).to have_content "100"
    end
  end
end