require './lib/db_connection.rb'
require './lib/associatable.rb'
require './lib/associatable2.rb'
require './lib/db_connection.rb'
require './lib/searchable.rb'
require './lib/sql_object.rb'
require './lib/attr_accessor_object.rb'

DBConnection.open('./test.db')

class Post < SQLObject
  attr_accessor :id, :body, :author_id

  belongs_to :user, foreign_key: :author_id
  has_one_through :channel, :user, :channel
end


class User < SQLObject
  attr_accessor :id, :fname, :lname, :channel_id

  has_many :posts, foreign_key: :author_id
  belongs_to :channel
end


class Channel < SQLObject
  attr_accessor :id, :name
  has_many :users,
    class_name: 'User',
    foreign_key: :channel_id,
    primary_key: :id
end


puts "Enter Commands, such as User.find(1).posts"
