require 'sinatra'
require 'slim'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
# DataMapper.setup(:default, 'sqlite:recall.db')

class Juice
  include DataMapper::Resource

  property :id,           Serial
  property :brand,        String
  property :name,         String
  property :completed_at, DateTime
end

get '/' do
end

# view a perfume/juice
get '/juice/:id' do
  @juice = Juice.get(params[:id])
  erb :index
end

get '/nicky' do
  "blah blah blah, droned Nicky."
end

DataMapper.auto_upgrade!

not_found do
  halt 404, "whoa there big thunder! page not found, sorrrrri."
end
