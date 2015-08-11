module Dwek
  module SubjectTableFactory

    # loads the temporary subjects table
    def self.build
      temp_table = TempTable::Builder.new('subjects')
      temp_table.build_from([
        TempTable::Column.new(name: :mapped_attributes, type: :text)
      ], id: :string)

      temp_table.build_class do
        self.primary_key = :id
        serialize :mapped_attributes
      end
    end
  end
end
