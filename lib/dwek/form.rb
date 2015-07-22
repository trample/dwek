module Dwek
  class Form

    def initialize(name)
      @name = name
      @records = []
      self.class.cache[@name] = self
    end

    def <<(record)
      @records << record
    end

    def get(subject_id)
      @records.select { |record| record[:subject_id] == subject_id }
    end

    class << self
      def cache
        @cache ||= {}
      end
    end
  end
end
