require 'sinatra'
require 'slim'
require 'data_mapper'
#require 'dm-sqlite-adapter'
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-github'
require 'omniauth-facebook'
require './keys.rb'
require 'pry'

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

  has n, :persons, :through => Resource
end

class Person
  include DataMapper::Resource

  property :id, Serial
  property :uid, String
  property :username, String
  property :email, String
  property :created_at, DateTime

  has n, :juices, :through => Resource
end

class Own
  include DataMapper::Resource

  belongs_to :Person, :key => true
  belongs_to :Juice, :key => true
end

class Wish
  include DataMapper::Resource

  belongs_to :Person, :key => true
  belongs_to :Juice, :key => true
end

enable :sessions
enable :inline_templates

helpers do
  def current_user
    @current_user ||= Person.get(session[:user_id]) if session[:user_id]
  end
end

get '/' do
  @juices = Juice.all
  erb :index
end

#get '/auth/:name/:callback' do
#  auth = request.env["omniauth.auth"]
#  user = Person.first_or_create({ :uid => auth["uid"]},{
#    :uid => auth["uid"],
#    :created_at => Time.new })
#    session[:user_id] = user.id
#  "hello"
#end

# any of the following routes should work to sign the user in: 
#   /sign_up, /signup, /sign_in, /signin, /log_in, /login
["/sign_in/?", "/signin/?", "/log_in/?", "/login/?", "/sign_up/?", "/signup/?"].each do |path|
  get path do
    redirect '/auth/twitter' # how do i toggle this for github & facebook?
  end
end

["/sign_out/?", "/signout/?", "/log_out/?", "/logout/?"].each do |path|
  get path do
    session[:user_id] = nil
    redirect '/'
  end
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

#  validation_passes = [
#    :username, :activity, :location
#  ].all? { |k| params[k] and !params[k].strip.empty? }
#
#  # preprocess.  store visitor's username in cookie.
#  session["visitor_name"] = params[:username]
#  # { "visitor_name" => "Goldie Hawn" }
#  session["visitor_location"] = params[:location]


end

get '/user' do
  @person = current_user

  if current_user
    # The following line just tests to see that it's working.
    #   If you've logged in your first user, '/' should load: "1 ... 1";
    #   You can then remove the following line, start using view templates, etc.
    current_user.id.to_s + " ... " + session[:user_id].to_s 
  else
    'Greetings. <a href="/sign_in">Sign in with Twitter</a>'
    # if you replace the above line with the following line, 
    #   the user gets signed in automatically. Could be useful. 
    #   Could also break user expectations.
    # redirect '/auth/twitter'
  end

end


get '/auth/:name/:callback' do # from charlie park's "omniauth for sinatra" repo
  auth = request.env["omniauth.auth"]
  user = Person.first_or_create({ :uid => auth["uid"]}, { # what about the 'create' part?
#    :provider => auth["provider"],   # alan says WHY DID YOU DO THIS
    :uid => auth["uid"],
    :username => auth["info"]["nickname"],
    :created_at => Time.now })
  session[:user_id] = user.id

  "hello #{user.username}. Welcome to Neiman Marcus."
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



get '/add/:id/:brand/:name' do
  j = Juice.new
  j.id = params[:id]
  j.brand = params[:brand]
  j.name = params[:name]
  j.save
  "i hope that saved, lol."
end

get '/nicky' do
  "blah blah blah, droned Nicky endlessly on the phone."
end

get '/ben/:victim' do
  "Ben has been eating #{params[:victim]} since #{Time.now}. What a lunatic!"
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
