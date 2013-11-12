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
  property :brand,        String, :required => true
  property :name,         String, :required => true
  property :used,         DateTime
  property :added,        DateTime
  property :size,         String
  property :formula,      String
  property :description,  String

  belongs_to :person
end

class Person
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :email, String
  property :created_at, DateTime

  has n, :juices
end

get '/' do
  @juices = Juice.all
  erb :index
end

post '/juice/create' do
  juice = Juice.new(:name =>  params[:name],
                    :brand => params[:brand])
  if juice.save
    status 201
    redirect "/"
  else
    status 412
    redirect '/juices'
  end
end

# view a perfume/juice
#get '/juice/:id' do
get %r{\A/juice/(\d+)\Z} do |id| # useful regex
  @juice = Juice.get(id.to_i)
#  erb :edit
  erb :juice
  #"testing: #{@juice.id}, #{@juice.name}"
end

get '/juice/:id/edit' do
  @juice = Juice.get(params[:id])
  erb :edit
end

put '/juice/:id' do
  juice = Juice.get(params[:id])
  juice.used = params[:used] ? Time.now : nil
  juice.name = (params[:name])
  juice.brand = (params[:brand])
  if juice.save
    status 201
    redirect '/'
  else
    status 412
    redirect '/juices/'
  end
end

get '/juices' do
  @juices = Juice.all
  erb :index
end

get '/juice/:id/delete' do
  @juice = Juice.get(params[:id])
  erb :delete
end

delete '/juice/:id' do
  Juice.get(params[:id]).destroy
  redirect '/juices'
end

get '/wishlist' do
  erb :wishlist
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

not_found do
  halt 404, "whoa there big thunder! page not found, sorrrrri."
end

DataMapper.auto_upgrade!

# NEXT
# -add menu/template
#
# EVENTUALLY:
# -add custom sort labels
# -allow flacons to be sorted by manufacturer, date added
# -want vs really want vs kind of want
