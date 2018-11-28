require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @primary_key = options[:primary_key] ||= :id
    @foreign_key = options[:foreign_key] ||= (name.to_s + "_id").to_sym
    @class_name = options[:class_name] ||= name.to_s.titleize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @primary_key = options[:primary_key] ||= :id
    @foreign_key = options[:foreign_key] ||= (self_class_name.to_s + "_id").downcase.to_sym
    @class_name = options[:class_name] ||= name.to_s.titleize.singularize
  end
end

module Associatable

  def belongs_to(name, options = {})
    options_obj = BelongsToOptions.new(name, options)
    self.assoc_options[name.to_s.singularize.to_sym] = options_obj
    define_method(name) do
      foreign_key = send(:id)
      options_obj.model_class.where(:id => foreign_key).first
    end
  end

  def has_many(name, options = {})
    options_obj = HasManyOptions.new(name, self, options)
    define_method(name) do
      foreign_key = send(:id)
      options_obj.model_class.where(options_obj.foreign_key => foreign_key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
