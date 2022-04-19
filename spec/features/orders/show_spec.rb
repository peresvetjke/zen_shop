require "rails_helper"

feature 'User as customer can view the order', %q{
  In order to check its details.
} do

  given!(:user)           { create(:user) }
  given!(:order)          { create(:order, user: user) }

  background { sign_in(user) }

  feature "index order" do
    it "displays order" do
      visit order_path(order)
      expect(page).to have_content(order.id.to_s)
      order.order_items.each do |i|
        expect(page).to have_content(i.item.title)
      end
      # expect(page).to have_content(order.sum.to_s)
    end
  end
end