module Dwek
  # stores records about a certain set of data for a group of subject
  class Form

    attr_accessor :klass

    # initialize the list of records
    def initialize(filepath)
      name = Pathname(filepath).basename('.csv').to_s
      self.class.cache[name] = self

      temp_table = TempTable::Builder.new(name)
      temp_table.import_from(filepath)
      self.klass = temp_table.build_class
    end

    # retrieve all records for a given subject id
    def get(subject_id)
      klass.where(subject: subject_id)
    end

    class << self
      # the cache of all available forms
      def cache
        @cache ||= {}
      end
    end
  end
end
