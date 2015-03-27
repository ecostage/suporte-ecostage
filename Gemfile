source "https://rubygems.org"

gem "coffee-rails"
gem "delayed_job_active_record"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "i18n-tasks"
gem "jquery-rails"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "rack-timeout"
gem "rails", "~> 4.1.6"
gem "recipient_interceptor"
gem "sass-rails"
gem "simple_form"
gem "title"
gem "uglifier"
gem "devise"
gem "bootstrap-sass"
gem "font-awesome-sass"
gem 'select2-rails'
gem 'pundit'
gem 'kaminari'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'pg_search'
gem 'paperclip'
gem 'aws-sdk'
gem 'chart-js-rails'
gem 'mail_view'
gem 'unicorn'
gem 'unicorn-rails'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem 'faker'
end

group :development, :test do
  gem "dotenv-rails"
  gem "awesome_print"
  gem "byebug"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.0.0"
  gem "vcr"
end

group :test do
  gem "rspec"
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "timecop"
  gem "webmock"
  gem "poltergeist"
end

group :staging, :production do
  gem "newrelic_rpm", ">= 3.7.3"
end
