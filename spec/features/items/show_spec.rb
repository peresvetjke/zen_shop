require "rails_helper"

feature 'User as client can view item', %q{
  In order to get familiar with its details and purchase.
} do

  given(:user) { create(:user) }
  given(:item) { create(:item) }

  background { 
    sign_in(user)
    visit item_path(item) 
  }

  scenario "displays item" do
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.price)
    expect(page).to have_content(item.description)
  end

  feature "stocks" do
    scenario "displays available amount" do
      expect(item.available_amount).to eq 100
      expect(page).to have_content "Available: 100"
    end
  end
end