class Omni::AuthFinder
  attr_reader :provider, :uid, :email

  def initialize(auth)
    @provider = auth.provider
    @uid = auth.uid
    @email = auth.info&.email
  end

  def call
    authentication = Authentication.find_by(provider: provider, uid: uid)
    user = authentication&.user
    return user if user

    if email&.present?
      user = User.find_by(email: email) || create_user
      user.create_authentication(provider: provider, uid: uid) unless authentication
    end

    user
  end

  private

  def create_user
    User.create!(email: email, password: Devise.friendly_token[0, 20])
  end
end