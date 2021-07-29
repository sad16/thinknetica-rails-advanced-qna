class AuthorizationMailer < ApplicationMailer
  def confirmation_email(auth)
    @auth = auth
    mail(to: @auth.email, subject: 'Confirmation Email')
  end
end
