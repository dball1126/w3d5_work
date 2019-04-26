require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
      return @columns unless @columns.nil?
    result = DBConnection.execute2(<<-SQL)
          SELECT
            *
          FROM
          #{self.table_name}
          SQL

    @columns = result.first.map{|col| col.to_sym }
  end

  def self.finalize!
      

        self.columns.each do |col|
           define_method(col) do 
          # self.instance_variable_get("@#{col}")
          attributes[col]
          end

          define_method("#{col}=") do |value| 
        # self.instance_variable_set("@#{col}", value)
                attributes[col] = value
          end
        end
       
      
  end

  def self.table_name=(table_name)
   
          @table_name = table_name
    # ...
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
      # return @columns unless @columns.nil?
    result = DBConnection.execute(<<-SQL)
          SELECT
            *
          FROM
          #{self.table_name}
          SQL

      parse_all(result)
  end

  def self.parse_all(results)
        results.map { |ele| self.new(ele) }
  end

  def self.find(id)
      index = id
      result = DBConnection.execute(<<-SQL)
          SELECT
            *
          FROM
          #{self.table_name}
          WHERE
          id = #{index}
          LIMIT
          1
          SQL
      
      obj = result.first
     
      self.new(obj) if obj
    
  end

  def initialize(params = {})

        params.each do |key, value|
        
  raise "unknown attribute '#{key}'" if !self.class.columns.include?(key.to_sym)
          self.send("#{key}=", value)
        end

    # ...
  end

  def attributes
      @attributes ||= {}
  end

  def attribute_values
      self.attributes.values
  end

  def insert
          
  end

  def update
    # ...
  end

  def save
    # ...
  end
end