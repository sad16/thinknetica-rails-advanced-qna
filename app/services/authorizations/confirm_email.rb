module Services
  module Authorizations
    class ConfirmEmail < ApplicationService
      class Error < StandardError; end
      class ExpiredError < Error; end

      def call(auth)
        if auth.confirm_email_token_expires_at < Time.current
          auth.update!(confirm_email_token: nil, confirm_email_token_expires_at: nil)
          raise ExpiredError
        end

        auth.update!(
          email_confirmation_at: Time.current,
          confirm_email_token: nil,
          confirm_email_token_expires_at: nil
        )
      end
    end
  end
end
