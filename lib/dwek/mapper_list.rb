module Dwek
  class MapperList

    attr_accessor :mappers

    def initialize
      self.mappers = []
    end

    def add_mapper(*config)
      mappers << MapperFactory.build(*config)
    end

    def apply_to(subject)
      mappers.each do |mapper|
        mapper.apply_to(subject)
      end
    end
  end
end
