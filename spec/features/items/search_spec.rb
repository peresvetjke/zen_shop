require "rails_helper"

feature 'User as a client can perform search of goods item', %q{
  In order to minimize time of its discovering and purchase
}, js: true do

  given!(:category_one) { create(:category, title: "Category #1") }
  given!(:category_two) { create(:category, title: "Category #2") }
  given!(:item_one)     { create(:item, title: "Item #1 toy", category: category_one, price: Money.new(100_00, "RUB")) }
  given!(:item_two)     { create(:item, title: "Item #2 toy", category: category_one, price: Money.new(150_00, "RUB")) }
  given!(:item_three)   { create(:item, title: "Item #3", category: category_two, price: Money.new(200_00, "RUB")) }
  given!(:item_four)    { create(:item, title: "Item #4", category: category_two, price: Money.new(400_00, "RUB")) }

  background { 
    item_four.stock.update(storage_amount: 0)
    sign_in(create(:user))
  }

  feature "search by title" do
    it "returns items with relevant title" do
      visit items_path
      fill_in "query", with: "toy"
      click_button("Search")
      expect(page.all('div.item').count).to eq 2
      expect(page).to have_content "Item #1 toy"
      expect(page).to have_content "Item #2 toy"
    end
  end

  feature "search filter" do
    background {
      visit items_path
      sleep(0.5)
    }

    feature "filter search by category" do
      it "returns items with relevant category" do
        expect(page.all('.box.item').count).to eq 3
        page.check("Category #1")
        expect(page.all('.box.item').count).to eq 2
        expect(page).to have_content item_one.title
        expect(page).to have_no_content item_three.title
      end
    end

    feature "filter search by price" do
      it "returns items with relevant price" do
        expect(page.all('.box.item').count).to eq 3
        fill_in "input-format-from", with: "120"
        fill_in "input-format-to", with: "150"
        expect(page.all('.box.item').count).to eq 1
        expect(page).to have_content item_two.title
      end
    end

    feature "filter search by availability" do
      it "returns items with relevant price" do
        expect(page).to have_no_content item_four.title
        find(:css, "#is_available_checkbox").set(false)
        expect(page).to have_content item_four.title
      end
    end
  end
end