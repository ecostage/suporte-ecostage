require_relative "production"

Rails.application.configure do
  config.action_mailer.delivery_method = :test

  config.action_mailer.default_url_options = { host: 'staging.helpdesk.com' }
end
