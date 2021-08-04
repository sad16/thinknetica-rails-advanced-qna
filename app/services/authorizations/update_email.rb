module Services
  module Authorizations
    class UpdateEmail < ApplicationService
      class Error < StandardError; end
      class ExpiredError < Error; end

      def call(auth, email)
        if auth.enter_email_token_expires_at < Time.current
          auth.update!(enter_email_token: nil, enter_email_token_expires_at: nil)
          raise ExpiredError
        end

        auth.update!(
          email: email,
          confirm_email_token: Authorization.generate_unique_secure_token,
          confirm_email_token_expires_at: 1.hour.since,
          enter_email_token: nil,
          enter_email_token_expires_at: nil
        )

        auth
      end
    end
  end
end
