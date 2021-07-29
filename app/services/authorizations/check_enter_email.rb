module Services
  module Authorizations
    class CheckEnterEmail < ApplicationService
      class Error < StandardError; end
      class ExpiredError < Error; end

      def call(auth)
        if auth.enter_email_token_expires_at < Time.current
          auth.update!(enter_email_token: nil, enter_email_token_expires_at: nil)
          raise ExpiredError
        end

        true
      end
    end
  end
end
