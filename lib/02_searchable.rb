require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    keys = params.keys.map{|k| "#{k} = ?"}.join(" AND ")
    result = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{keys}
    SQL
    self.parse_all(result)
  end

end

class SQLObject
  extend Searchable
end
