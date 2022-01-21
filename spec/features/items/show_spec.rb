require "rails_helper"

feature 'User as client can view item', %q{
  In order to get familiar with its details and purchase.
} do

  given(:item) { create(:item) }
  background { visit item_path(item) }

  scenario "veiws item" do
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.price)
  end
end