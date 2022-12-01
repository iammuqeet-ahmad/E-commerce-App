# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.8', '>= 5.2.8.1'
gem 'sass-rails', '~> 5.0'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

gem 'bootstrap'
gem 'cloudinary'
gem 'devise'
gem 'figaro'
gem 'jquery-rails'
gem 'kaminari'
gem 'pundit'
gem 'ransack'
gem 'stripe'

gem 'active_model_serializers', '~> 0.10.0'
gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end
group :test do
  gem 'capybara', '>= 2.15'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'shoulda-callback-matchers'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
