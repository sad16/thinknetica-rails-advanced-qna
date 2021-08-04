module Services
  module Authorizations
    class SendConfirmationMail < ApplicationService
      def call(auth)
        AuthorizationMailer.confirmation_email(auth).deliver_later if auth.email
      end
    end
  end
end
