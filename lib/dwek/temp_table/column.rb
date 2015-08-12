module Dwek
  module TempTable
    class Column

      attr_accessor :name, :type

      def initialize(args = {})
        self.name = args[:name]
        self.type = args[:type] || :text
      end
    end
  end
end
