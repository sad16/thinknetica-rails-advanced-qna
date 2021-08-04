class AuthorizationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def enter_email
    @auth = Authorization.find_by!(enter_email_token: params[:enter_email_token])
    Services::Authorizations::CheckEnterEmail.new.call(@auth)

  rescue Services::Authorizations::CheckEnterEmail::ExpiredError
    redirect_to root_path, alert: 'Time to enter email has expired'
  end

  def update_email
    auth = Authorization.find_by!(enter_email_token: params[:enter_email_token])
    auth = Services::Authorizations::UpdateEmail.new.call(auth, params[:email])
    Services::Authorizations::SendConfirmationMail.new.call(auth)

    redirect_to new_user_session_path, notice: 'Сonfirmation mail was sent to the email'
  rescue Services::Authorizations::UpdateEmail::ExpiredError
    redirect_to root_path, alert: 'Time to enter email has expired'
  end

  def confirm_email
    auth = Authorization.find_by!(confirm_email_token: params[:confirm_email_token])
    Services::Authorizations::ConfirmEmail.new.call(auth)

    redirect_to new_user_session_path, notice: 'Email confirmed. You can sign in'
  rescue Services::Authorizations::ConfirmEmail::ExpiredError
    redirect_to root_path, alert: 'Time to confirm email has expired'
  end

  private

  def not_found
    head 404
  end
end
