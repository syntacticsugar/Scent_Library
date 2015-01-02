source "https://rubygems.org"

gem 'sinatra'
gem 'slim'
gem 'data_mapper'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'pry'
gem 'dotenv'

group :production do
  gem 'thin'
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :development do
  gem 'shotgun'
  gem 'pry'
end

gem 'dm-sqlite-adapter', group: [:test, :development]

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'simplecov'
  gem 'launchy'
  gem 'capybara'
  gem 'selenium-webdriver'
end
