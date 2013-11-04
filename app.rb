require 'sinatra'
require 'slim'
require 'data_mapper'
require 'dm-sqlite-adapter'

#require 'sqlite3'

#db = SQLite3::Database.new( "development.db" )
#rows = db.execute( "select * from test" )

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
  #erb :index
  "testing: #{@juice.id}, #{@juice.name}"
end

get '/add/:id/:brand/:name' do
  j = Juice.new
  j.id = params[:id]
  j.brand = params[:brand]
  j.name = params[:name]
  j.completed_at = Time.now
  j.save
  "i hope that saved, lol."
end

get '/add' do
  j = Juice.new
  j.id = 10
  j.brand = 'Jizz'
  j.name = 'Oralification'
  j.completed_at = Time.now
  j.save
  "saved (I hope)"
end

get '/nicky' do
  "blah blah blah, droned Nicky."
end

DataMapper.auto_upgrade!

not_found do
  halt 404, "whoa there big thunder! page not found, sorrrrri."
end
