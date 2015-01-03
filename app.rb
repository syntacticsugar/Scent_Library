require 'bundler'

require "sinatra"
require 'dotenv'
Dotenv.load
Bundler.require :default, Sinatra::Application.environment
set :root, File.dirname(__FILE__)

require_relative 'keys.rb'
require_relative 'model.rb'

enable :sessions
enable :inline_templates

set :slim, :pretty => development?

helpers do
  def current_user
    @current_user ||= Person.get(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end
end

get '/' do
  if logged_in?
    @juices = current_user.juices(:order => [ :brand.asc, :name.asc ])

    if params[:wishlist_only]
      @juices = @juices.select do |juice|
        @list_type = "wishlist"
        PersonJuice.get(current_user.id, juice.id).wished_for?
      end
    elsif params[:to_buy_only]
      @juices = @juices.select do |juice|
        @list_type = "shopping list"
        PersonJuice.get(current_user.id, juice.id).to_buy?
      end
    elsif params[:own_only]
      @juices = @juices.select do |juice|
        @list_type = "collection"
        PersonJuice.get(current_user.id, juice.id).owned?
      end
    end
  else
    @juices = Juice.all(:order => [ :created_at.desc ], :limit => 20) # .take 20 or .first 20 works, also
  end

  slim :index
end

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
  list_type = params[:list_type]

  if not logged_in?
    halt 401
  else
    juice = Juice.new(:name =>  params[:name],
                      :brand => params[:brand])

    juice.people << current_user

    if juice.save
      status 201
    else
      puts request.inspect
      status 412
    end
  end

  redirect '/'
end

get '/user' do
  @person = current_user

  if current_user
    # The following line just tests to see that it's working.
    #   If you've logged in your first user, '/' should load: "1 ... 1";
    #   You can then remove the following line, start using view templates, etc.
    current_user.id.to_s + " ... blah blah blah " + session[:user_id].to_s
  else
    'Greetings. <a href="/sign_in">Sign in with Twitter</a>'
  end
end


get '/auth/:name/:callback' do # from charlie park's "omniauth for sinatra" repo
  auth = request.env["omniauth.auth"]

  halt 400 unless %w[facebook twitter].include? auth["provider"]

  user = Person.first_or_create(:uid => auth["uid"])
   # Other info might have changed since we last authorised.
  user.provider = auth["provider"]
  user.nickname = auth["info"]["nickname"]
  user.name = auth["info"]["name"]
  user.image = auth["info"]["image"]
  user.save

  session[:user_id] = user.id

  redirect '/'
end

# Update values in PersonJuice
put '/person_juice' do
  @juice = Juice.get(params[:juice_id])

  assoc = PersonJuice.get(current_user.id, @juice.id)
  # sets the labels *IF* the params.key(:item) are passed as parameters
  # otherwise, if it is not set, it will default to nil, and !!nil is FALSE
  assoc.wished_for = (params[:wished_for] == "1") if params.key?("wished_for")
  assoc.owned = (params[:owned] == "1") if params.key?("owned")
  assoc.to_buy = (params[:to_buy] == "1") if params.key?("to_buy")

  assoc.rating = (params[:rating] == "unset" ? nil : params[:rating]) if params.key?("rating")
  assoc.notes = params[:notes] if params.key?("notes") # remember, text, not a boolean
  assoc.save

  redirect "/juice/#{@juice.id}"
end

# View a perfume
get '/juice/:id' do
  @juice = Juice.get(params[:id])
  halt 400 if @juice.nil?

  @assoc = if logged_in?
             PersonJuice.get(current_user.id, @juice.id)
           else
             nil
           end
  slim :juice
end

# Edit a perfume
get '/juice/:id/edit' do
  @juice = Juice.get(params[:id])
  slim :edit
end

# Update a perfume.
put '/juice/:id' do
  juice = Juice.get(params[:id])
  halt 400 if @juice.nil?

  juice.name = params[:name] if params[:name]
  juice.brand = params[:brand] if params[:brand]

  if juice.save
    status 201
    redirect '/'
  else
    status 412
    redirect '/juices/'
  end
end

# See all perfumes.
get '/juices' do
  @juices = Juice.all(:order => [ :brand.asc, :name.asc ])
  slim :index
end

# Confirm deletion of a perfume.
get '/juice/:id/delete' do
  @juice = Juice.get(params[:id])
  slim :delete
end

# Delete a perfume.
delete '/juice/:id' do
  # Destroy associations to people.
  Juice.get(params[:id]).person_juices.destroy!
  # destroy the juice itself.
  Juice.get(params[:id]).destroy!
  redirect '/'
end

# Odd way to add a perform (should use 'post /juice?brand=Channel&name=5')
get '/add/:brand/:name' do
  j = Juice.new
  j.brand = params[:brand]
  j.name = params[:name]
  j.save
  "i hope that saved, lol."
end

get '/faq' do
  slim :"faq"
end

get '/nicky' do
  "blah blah blah, droned Nicky endlessly on the phone."
end

get '/ruby' do
  "ruby childs"
end

not_found do
  halt 404, "whoa there big thunder! page not found, sorrrrri."
end

=begin
# Get list of currently managed routes.
%w[GET PUT POST].each do |fetch|
  puts
  puts "Routes for #{fetch}"
  Sinatra::Application.routes[fetch].each do |route|
    p route.first
  end
end
=end

# NEXT
# -"updated" once user has clicked 'updated'
# -add menu/template
# -
# -add text/description
# -add to wishlist only on mouseover
# -why is font so small in Firefox? (+ logo rollover inconsistency)
# -make lists/user accounts private if they choose to be private
#
# EVENTUALLY:
# -add custom sort labels (?)
# -allow flacons to be sorted by manufacturer, date added
# -add some sort of page-caching, so if the last page users
#       used is 'wishlist', it will show wishlist items the
#       next time they visit the site.
# -OMG awesome upcoming feature: auto-add to the database:
#       -as soon as the user types 1 perfume, another row of
#       input fields appear underneath.
#       -as soon as the user CLICKS on the new row, the PREVIOUS
#       row of perfume gets automatically added to the database!
