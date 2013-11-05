%w( sinatra slim data_mapper dm-sqlite-adapter ).each { |gem| require gem }

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/lettuce.db")

class Juice
  include DataMapper::Resource

  property :id,              Serial
  property :name,            String
  property :brand,           String
  property :completed_at,    DateTime

end

get '/juice/:id' do
  @juice = Juice.get(params[:id])
  erb :juice
end

get '/juice/new' do
  erb :new
end

# create new juice
post '/juice/create' do
  juice = Juice.new(:name => params[:name])
  if juice.save
    status 201
    redirect '/juice/'+juice.id.to_s
  else
    status 412
    redirect '/juices'
  end
end

DataMapper.auto_upgrade!

