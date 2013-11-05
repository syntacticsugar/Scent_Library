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
  erb :index
end

get '/juice/new' do
  erb :new
end

post '/juice/create' do
  juice = Juice.new(:name => params[:name])
  if juice.save
    status 201
    redirect "/juice/#{juice.id}"
  else
    status 412
    redirect '/juices'
  end
end

# view a perfume/juice
#get '/juice/:id' do
get %r{/juice/\d+} do |id|
  @juice = Juice.get(params[id])
  erb :juice
  #"testing: #{@juice.id}, #{@juice.name}"
end

#get '/add/:id/:brand/:name' do
#  j = Juice.new
#  j.id = params[:id]
#  j.brand = params[:brand]
#  j.name = params[:name]
#  j.completed_at = Time.now
#  j.save
#  "i hope that saved, lol."
#end

get '/nicky' do
  "blah blah blah, droned Nicky endlessly on the phone."
end

DataMapper.auto_upgrade!

not_found do
  halt 404, "whoa there big thunder! page not found, sorrrrri."
end
