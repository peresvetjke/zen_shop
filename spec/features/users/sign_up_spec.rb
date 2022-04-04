require "rails_helper"

feature 'User can register', %q{
  In order to sign in
  and purchase goods
} do
  
  feature "signs up using login ans password" do
    background { visit new_user_registration_path } 
  
    scenario "tries to register with blank email" do
      fill_in "Email", :with => ""
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"
      click_button "Sign up"
      expect(page).to have_text("Email can't be blank")
    end

    scenario "tries to register with blank password" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => ""
      fill_in "Password confirmation", :with => ""
      click_button "Sign up"
      expect(page).to have_text("Password can't be blank")
    end

    scenario "tries to register with confirmation password not matched" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "passwordxxx"
      click_button "Sign up"
      expect(page).to have_text("Password confirmation doesn't match")
    end

    scenario "tries to register with email which is taken" do
      user = create(:user)
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      fill_in "Password confirmation", :with => user.password
      click_button "Sign up"
      expect(page).to have_text("Email has already been taken")
    end

    scenario "registers with correct credentials" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"
      click_button "Sign up"
      expect(page).to have_text("You have signed up successfully")
    end
  end
end