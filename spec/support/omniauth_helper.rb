module OmniauthHelper
  def mock_github_auth_hash(email)
    auth_hash = OmniAuth::AuthHash.new(
      {
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
          'email' => email
        }
      }
    )

    OmniAuth.config.mock_auth[:github] = auth_hash
  end

  def mock_vkontakte_auth_hash
    auth_hash = OmniAuth::AuthHash.new(
      {
        'provider' => 'vkontakte',
        'uid' => '123545',
        'info' => {}
      }
    )

    OmniAuth.config.mock_auth[:vkontakte] = auth_hash
  end

  def mock_invalid_credentials(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
