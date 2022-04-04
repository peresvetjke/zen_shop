require "rails_helper"

feature 'User as client can rate an item', %q{
  In order to provide feedback.
}, js: true do

  given!(:user) { create(:user) }
  given!(:item) { create(:item) }
  
  background { sign_in(user) }
  
  scenario "saves product rating" do
    visit item_path(item)
    find('trix-editor').click.set('My review')
    click_button('Rate product')
    sleep(0.5)
    expect(page.first('.item .rating')).to have_content '5.0'
  end
end