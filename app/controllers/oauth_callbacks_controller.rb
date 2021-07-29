class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    result = Services::Authorizations::Oauth.new.call(omniauth_data)
    redirect_process(result)
  end

  def vkontakte
    result = Services::Authorizations::Oauth.new.call(omniauth_data)
    redirect_process(result)
  end

  private

  def redirect_process(oauth)
    if oauth[:user]
      sign_in_and_redirect oauth[:user], event: :authentication

      kind = oauth[:auth].provider.to_s.capitalize
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    elsif oauth[:auth]
      token = oauth[:auth].enter_email_token
      redirect_to auth_enter_email_path(enter_email_token: token), notice: 'Enter your email for confirmation'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def omniauth_data
    request.env['omniauth.auth']
  end
end
