ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "paperclip/matchers"
require "capybara/poltergeist"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
  include UserSession
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.color = true

  config.tty = true

  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"
  config.use_transactional_fixtures = false
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, :type => :controller
  config.include Paperclip::Shoulda::Matchers
  Capybara.javascript_driver = :poltergeist
end

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)
