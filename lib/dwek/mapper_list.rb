module Dwek
  class MapperList

    attr_accessor :mappers

    def initialize
      self.mappers = []
    end

    def add_mapper(*config)
      mappers << MapperFactory.build(*config)
    end
  end
end
