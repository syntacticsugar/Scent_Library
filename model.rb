require 'data_mapper'
require 'dm-timestamps'

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_COPPER_URL'] || "sqlite3://#{Dir.pwd}/development.db")


class Juice
  include DataMapper::Resource

  property :id,           Serial
  property :brand,        String, :required => true
  property :name,         String, :required => true
  property :created_at, DateTime # Magic property will be set automatically.
  property :size,         String
  property :formula,      String
  property :description,  String

  has n, :person_juices
  has n, :people, "Person", :through => :person_juices
end


class Person
  include DataMapper::Resource

  property :id, Serial
  property :uid, String, :unique => true
  property :nickname, String
  property :name, String
  property :provider, String
  property :image, String, :length => 1000
  property :email, String
  property :created_at, DateTime # Magic property will be set automatically.

  has n, :person_juices
  has n, :juices, :through => :person_juices
end


class PersonJuice
  include DataMapper::Resource

  RATING_RANGE = 0..5

  belongs_to :person, :key => true
  belongs_to :juice, :key => true

  property :owned, Boolean, :default => false
  property :wished_for, Boolean, :default => false
  property :to_buy, Boolean, :default => false
  property :used_at, DateTime
  property :rating, Integer
  property :notes, String, :length => 0..1500

  validates_within :rating, :set => RATING_RANGE.to_a + [nil]
end

DataMapper.auto_upgrade!
