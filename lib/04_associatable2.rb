require_relative '03_associatable'


module Associatable
  
  def has_one_through(name, through_name, source_name)

    through_options = self.assoc_options[through_name]

    define_method(name) do

      source_options = through_options.model_class.assoc_options[source_name]
      select_var = source_options.class_name.downcase + "s"
      from_var = through_options.class_name.downcase + "s"
      where_var = from_var + "." + source_options.primary_key.to_s

      result = DBConnection.execute(<<-SQL, self.id)
        SELECT
          #{select_var}.*
        FROM
          #{from_var}
        JOIN
          #{source_options.class_name.tableize} ON #{from_var + "." + source_options.foreign_key.to_s} = #{select_var + "." + through_options.primary_key.to_s}
        WHERE
          #{where_var} = ?
      SQL
      source_name.to_s.titleize.constantize.new(result.first)

    end
  end
end
