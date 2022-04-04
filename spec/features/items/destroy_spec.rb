require "rails_helper"

feature 'User as an admin can delete category', %q{
  In order to actualize items classification.
}, js: true do

  let!(:item) { create(:item) }

  shared_examples "guest" do
    scenario "tries to delete an item " do
      visit admin_items_path
      expect(page).to have_content I18n.t("devise.failure.unauthenticated")
    end
  end

  shared_examples "customer" do
    scenario "tries to delete an item" do
      visit admin_items_path
      expect(page).to have_content I18n.t("pundit.admin/item_policy.destroy?")
    end
  end  

  shared_examples "admin" do
    feature "with no relevant orders" do
      scenario "deletes the item" do
        visit admin_items_path
        within("turbo-frame##{dom_id(item)}") do
          expect(page).to have_content item.title
          accept_confirm { click_link "Delete" }
        end
        expect(page).to have_no_content item.title
        expect(page).to have_content I18n.t("admin.items.destroy.message")
      end
    end

    feature "with relevant orders" do
      let!(:order) { create(:order) }

      scenario "does not allow to delete the item" do
        visit admin_items_path
        within("turbo-frame##{dom_id(order.order_items.first.item)}") do
          expect(page).to have_content order.order_items.first.item.title
          expect(page).to have_no_link "Delete"
        end
      end
    end
  end

  context "being a guest" do
    it_behaves_like "guest"
  end

  context "being a customer" do
    background { sign_in(create(:user)) }
    it_behaves_like "customer"
  end

  context "being an admin" do
    background { sign_in(create(:user, type: "Admin")) }
    it_behaves_like "admin"
  end
end