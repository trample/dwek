require 'csv'
require 'forwardable'

module Dwek
  module TempTable
    class Builder

      attr_accessor :columns, :klass, :klass_name, :table_name

      extend Forwardable
      def_delegators 'ActiveRecord::Base.connection', :execute, :quote_table_name, :table_exists?

      # build a new temporary table if the name is valid
      def initialize(name)
        name = name.gsub(/[^a-zA-Z0-9]/, '')
        self.klass_name = name.classify.to_sym
        self.table_name = "temp_table_#{name}"

        raise ArgumentError, 'class name is already taken' if (Dwek::TempTable.const_get(klass_name) rescue false)
        raise ArgumentError, 'table name is already taken' if table_exists?(table_name)
        @_initialized = false
      end

      # build an active record class for this table
      def build_class(&block)
        raise ArgumentError, 'Table must be initialized' unless @_initialized
        self.klass = Class.new(ActiveRecord::Base, &block)
        klass.table_name = table_name
        Dwek::TempTable.const_set(klass_name, klass)
      end

      # build the table with the given columns
      def build_from(columns, options = {})
        raise ArgumentError, 'Table already built' if @_initialized
        self.columns = columns
        create_table(options)
      end

      # import the table from the given CSV file
      def import_from(filepath, options = {}, &block)
        raise ArgumentError, 'Table already imported' if @_initialized

        self.columns = CSV.parse(File.open(filepath, &:readline)).first.map do |column|
          Column.new(name: column.squish.gsub(' ', '_').gsub(/[^a-zA-Z0-9_]/, '').downcase)
        end
        create_table(options)

        yield self if block_given?

        full_name = "#{quote_table_name(ActiveRecord::Base.connection.current_database)}.#{quote_table_name(table_name)}"
        execute(ActiveRecord::Base.send(:sanitize_sql_array, ["LOAD DATA LOCAL INFILE ? INTO TABLE #{full_name} FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES", filepath]))
      end

      private

        # create the table with the set columns
        def create_table(options = {})
          options.merge!(temporary: true)
          options.reverse_merge!(id: false)

          ActiveRecord::Migration.create_table(table_name.to_sym, options) do |t|
            columns.each { |column| t.send(column.type, column.name) }
          end
          @_initialized = true
        end
    end
  end
end
