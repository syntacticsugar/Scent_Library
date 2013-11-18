require 'data_mapper'
#require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_COPPER_URL'] || "sqlite3://#{Dir.pwd}/development.db")


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

  has n, :owners, "Person", :through => Resource
  has n, :wishers, "Person", :through => Resource
end


class Person
  include DataMapper::Resource

  property :id, Serial
  property :uid, String
  property :username, String
  property :email, String
  property :created_at, DateTime

  has n, :owned_perfumes, "Juice", :through => Resource
  has n, :wished_for_perfumes, "Juice", :through => Resource
end


DataMapper.auto_upgrade!