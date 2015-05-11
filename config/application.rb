require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Helpdesk
  class Application < Rails::Application
    config.active_record.default_timezone = :utc

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.action_mailer.smtp_settings = {
      address: ENV['MAILER_ADDRESS'],
      port: ENV['MAILER_PORT'] || 587,
      user_name: ENV['MAILER_USERNAME'],
      password: ENV['MAILER_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }

    config.active_record.schema_format = :sql
    config.i18n.enforce_available_locales = false
    config.action_view.raise_on_missing_translations = false
    config.time_zone = 'Brasilia'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'
    config.paperclip_defaults = { storage: :filesystem }
  end
end
