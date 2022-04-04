require "rails_helper"

feature 'User as customer can list all his orders', %q{
  In order to view history or check status of the specific order.
} do

  given!(:user)           { create(:user) }
  given!(:order)          { create(:order, user: user) }
  given!(:another_order)  { create(:order, user: user) }

  background { sign_in(user) }

  feature "index order" do
    it "displays all orders list" do
      visit root_path
      page.find('a', text: 'My orders').click
      expect(page).to have_content(order.id.to_s)
      expect(page).to have_content(another_order.id.to_s)
    end
  end
end