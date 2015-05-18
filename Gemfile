source 'https://rubygems.org'

ruby '2.1.2'
gem 'rails', '~> 4.1.6'

gem 'aws-sdk'
gem 'bootstrap-sass'
gem 'business_time'
gem 'chart-js-rails'
gem 'coffee-rails'
gem 'delayed_job_active_record'
gem 'devise'
gem 'dropzonejs-rails'
gem 'email_validator'
gem 'fist_of_fury', '~> 0.2.0'
gem 'flutie'
gem 'font-awesome-sass'
gem 'high_voltage'
gem 'holidays'
gem 'i18n-tasks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'kaminari'
gem 'mail_view'
gem 'normalize-rails', '~> 3.0.0'
gem 'paperclip'
gem 'pg'
gem 'pg_search'
gem 'pundit'
gem 'rack-timeout'
gem 'recipient_interceptor'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'sucker_punch', '~> 1.0'
gem 'title'
gem 'turbolinks'
gem 'uglifier'
gem 'unicorn'
gem 'unicorn-rails'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'faker'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'awesome_print'
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'vcr'
end

group :test do
  gem 'rspec'
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'poltergeist'
end

group :staging, :production do
  gem 'newrelic_rpm', '>= 3.7.3'
end
