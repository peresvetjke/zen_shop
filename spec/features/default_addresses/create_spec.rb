require "rails_helper"

feature 'User as customer can save default address', %q{
  In order to use it in further order placement.
}, js: true do

  # RSpec.configure do
  #   Capybara.javascript_driver = :selenium_chrome
  # end

  given(:user) { create(:user) }
  
  background { 
    sign_in(user) 
    visit account_path
  }

  scenario "saves default address" do
    fill_in 'address', with: "Покровка 16"
    sleep(1)
    page.first("span.suggestions-nowrap", text: "д 15/16").click
    sleep(1)
    click_button "Save"
    expect(page).to have_content('Default address has been succesfully updated.')
    expect(page).to have_field('house', with: '15/16')
  end
end