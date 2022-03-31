require "rails_helper"

feature 'User as client can index all items list', %q{
  In order to find the one he interested in
} do

  given(:user)       { create(:user) }
  given(:categories) { create_list(:category, 3) }  
  given(:category)   { Category.first }

  background { sign_in(user) }

  feature "without items" do
    it "indexes no items" do
      visit items_path
      expect(page).to have_text("No items at the moment.")
    end
  end

  feature "with few items" do
    background { categories.each { |cat| create_list(:item, 5, category: cat) } }

    scenario "indexing all the items" do
      visit items_path
      expect(page.all(' .item').count).to eq 15
      expect(Item.all.all?{ |i| page.has_content?(i.title) })
    end

    scenario "indexing items of selected category" do
      visit category_items_path(category)
      expect(page.all('.item').count).to eq 5
      expect(category.items.all?{ |i| page.has_content?(i.title) })
    end
  end
end