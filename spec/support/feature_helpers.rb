include ActionView::RecordIdentifier

module FeatureHelpers 
  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
    sleep(0.5)
  end

  def sign_out
    visit destroy_user_session_path
  end
end