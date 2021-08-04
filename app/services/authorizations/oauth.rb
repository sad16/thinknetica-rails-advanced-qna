module Services
  module Authorizations
    class Oauth < ApplicationService
      def call(omniauth_data)
        user, auth = ActiveRecord::Base.transaction do
          auth = find_or_create_authorization(omniauth_data)
          user = auth.email_confirmation_at ? find_or_create_user(auth) : nil
          auth.update!(user: user) if user

          [user, auth]
        end

        {
          user: user,
          auth: auth,
        }
      end

      private

      def find_or_create_authorization(omniauth_data)
        options = authorization_attributes(omniauth_data)
        auth = Authorization.find_or_initialize_by(options)
        return auth if auth.email_confirmation_at

        email = omniauth_data.info[:email]

        if email
          auth.email = email
          auth.email_confirmation_at = Time.current
        else
          auth.email = nil
          auth.enter_email_token = Authorization.generate_unique_secure_token
          auth.enter_email_token_expires_at = 5.minutes.since
          auth.confirm_email_token = nil
          auth.confirm_email_token_expires_at = nil
        end

        auth.save!
        auth
      end

      def find_or_create_user(auth)
        user = User.find_or_initialize_by(email: auth.email)

        if user.new_record?
          password = User.generate_unique_secure_token
          user.password = password
          user.password_confirmation = password
          user.save!
        end

        user
      end

      def authorization_attributes(omniauth_data)
        {
          provider: omniauth_data.provider,
          uid: omniauth_data.uid.to_s
        }.compact
      end
    end
  end
end
