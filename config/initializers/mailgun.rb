Mailgun.configure do |config|
  config.api_key = Rails.application.credentials[Rails.env.to_sym][:mailgun][:api_key]
end
