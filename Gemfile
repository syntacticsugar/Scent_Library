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
  gem 'dm-sqlite-adapter'
end
