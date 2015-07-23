module Dwek
  # stores records about a certain set of data for a group of subject
  class Form

    # initialize the list of records
    def initialize(name)
      @records = []
      self.class.cache[name] = self
    end

    # add a record to the list
    def <<(record)
      @records << record
    end

    # retrieve all records for a given subject id
    def get(subject_id)
      @records.select { |record| record[:subject_id] == subject_id }
    end

    class << self
      # the cache of all available forms
      def cache
        @cache ||= {}
      end
    end
  end
end
