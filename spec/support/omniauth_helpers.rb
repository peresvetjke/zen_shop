module OmniauthHelpers
  def mock_auth_hash(provider: 'github', email: 'user@example.com')
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
        :provider => provider,
        :uid => '12345677',
        :info => {
          :email => email
        }
        # etc.
      })
  end
end