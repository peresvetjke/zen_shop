require "rails_helper"

feature 'User as customer can update default address', js: true do

  given!(:user)            { create(:user) }
  given!(:default_address) { create(:default_address, user: user) }
  
  background { 
    sign_in(user) 
    visit account_path
  }

  scenario "updates default address" do
    page.find("a", text: "Change").click
    fill_in 'address', with: "Покровка 10"
    sleep(1)
    page.first("span.suggestions-nowrap", text: "д 10").click
    sleep(1)
    click_button "Save"
    expect(page).to have_field('house', with: '10')
    expect(page).to have_content('Default address has been succesfully updated.')
  end
end