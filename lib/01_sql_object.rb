require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns
    array = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT 1
    SQL
    @columns = array.first.map{|e| e.to_sym}
  end

  def self.finalize!
    self.columns.map{|e|e.to_s}.each do |name|
      define_method("#{name}="){|val| self.attributes[name.to_sym] = val}
      define_method(name){self.attributes[name.to_sym]}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    @all = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL
    self.parse_all(@all)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

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

  def initialize(params = {})
    params.each do |key, value|
      if self.class.columns.include?(key.to_sym)
        self.send("#{key}=", value)
      else
        raise Exception.new("unknown attribute '#{key}'")
      end
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    self.attributes.values
  end

  def insert
    col_names = self.class::columns.join(",")
    col_names = col_names[col_names.index(',')+1..col_names.length]
    question_mark_arr = []

    (self.class::columns.length - 1).times do
      question_mark_arr << "?"
    end
    q_mark_str = question_mark_arr.join(',')
    args = self.attribute_values

    DBConnection.execute(<<-SQL, *self.attribute_values)
      INSERT INTO
        #{self.class::table_name} (#{col_names})
      VALUES
        (#{q_mark_str})
      SQL

      self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class::columns.map{|col| "#{col} = ?"}.join(",")
    col_names = col_names[col_names.index(",")+1..col_names.length]
    args = self.attribute_values.drop(1)

    DBConnection.execute(<<-SQL, *args, self.id)
      UPDATE
        #{self.class::table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL
  end

  def save
    if self.id
      self.update
    else
      self.insert
    end
  end
end
