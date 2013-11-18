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

  has n, :person_juices
  has n, :people, "Person", :through => :person_juices
end


class Person
  include DataMapper::Resource

  property :id, Serial
  property :uid, String
  property :username, String
  property :email, String
  property :created_at, DateTime

  has n, :person_juices
  has n, :juices, :through => :person_juices
end


class PersonJuice
  include DataMapper::Resource

  belongs_to :juice, :key => true
  belongs_to :person, :key => true

  property :owned, Boolean, :default => false
  property :wished_for, Boolean, :default => false
  
  property :rating, Integer # 0 to 10
end

DataMapper.auto_upgrade!