# frozen_string_literal: true

source 'https://rubygems.org'

# Core
gem 'rails', '~> 8.0.1'
gem 'propshaft'
gem 'sqlite3', '>= 2.1'
gem 'puma', '>= 5.0'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'bootsnap', require: false

# System dependencies
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'
gem 'rails_app_version', '1.2.4'

# Application
gem 'css-zero', '1.1.7'
gem 'devise', '4.9.4'
gem 'pagy', '~> 9.3.3'
gem 'ransack', '~> 4.2.1'

# Deploy
gem 'kamal', require: false
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.14'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'rspec-rails', '~> 7.1.1'
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  gem 'amazing_print'
  gem 'annotaterb'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hotwire-spark'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
  gem 'timecop'
end
