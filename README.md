# Welcome to ProactiveRecord!

A study of the inner workings of Rails, Proactive Record is an ORM that provides many of the most utilized features of Active Record. Using Ruby's metaprogramming capabilities in conjunction with SQL, Proactive Record enables one to query their SQL database and create associations with the familiar ease of Active Record.

## SQL Object

At the core of ProactiveRecord is the ```SQLObject``` class. The ```SQLObject``` class provides many of ActiveRecord's most common features, including ```find```, ```insert```, ```update```, and ```save```.

All of these features perform basic SQL queries through the employment of the ```DBConnection class```. In using this class, we are able to replicate find, as well as other features, as follows:

```ruby
def self.find(id)
    result = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        id = #{id}
      LIMIT
        1
    SQL
    unless result.empty?
      self.new(result.first)
    else
      nil
    end
end
```

## Associatable

The ```Associatable``` class enables us to form associations just as we would in ActiveRecord. ProactiveRecord supports ```belongs_to```, ```has_many```, and ```has_one_through```. Again, these associations, are created through the employment of the ```DBConnection``` class as can be seen in the following:

```ruby
def belongs_to(name, options = {})
    options_obj = BelongsToOptions.new(name, options)
    self.assoc_options[name.to_s.singularize.to_sym] = options_obj
    define_method(name) do
      foreign_key = send(:id)
      options_obj.model_class.where(:id => foreign_key).first
    end
end
```

### Example

To test Proactive Record, first clone this repository.

Run rails db:create

Load these files into your Rails console and test on the sample database provided.
