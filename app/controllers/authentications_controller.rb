class AuthenticationsController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[github]

  def github
    provider('Github')
  end

  private

  def provider(kind)
    byebug
    user = User.find_for_oauth(request.env['omniauth.auth'])

    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      save_provider_info
      redirect_to new_user_registration_url
    end
  end

  def save_provider_info
    session['oauth.uid'] = request.env['omniauth.auth'].uid.to_s
    session['oauth.provider'] = request.env['omniauth.auth'].provider
  end
end