require './lib'

DBConnection.open('db/cats.sqlite3')

class Post < SQLObject
  my_attr_accessor :id, :name, :author_id

  belongs_to :user, foreign_key: :author_id
  has_one_through :channel, :user, :channel
end


class User < SQLObject
  my_attr_accessor :id, :fname, :lname, :channel_id

  has_many :posts, foreign_key: :author_id
  belongs_to :channel
end


class Channel < SQLObject
  my_attr_accessor :id, :address
  has_many :users,
    class_name: 'User',
    foreign_key: :channel_id,
    primary_key: :id
end


puts "Enter Commands, such as User.find(1)"
