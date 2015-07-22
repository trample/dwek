module Dwek
  class MapperList

    attr_reader :mappers

    def initialize(configuration = [])
      @mappers = []
      configuration.each do |mapper_config|
        self.add_mapper(*mapper_config)
      end
    end

    def add_mapper(destination, mapper_type, options, sub_mappers = [])
      mapper_class = Dwek::Mappers.const_get(mapper_type.to_s.camelize + 'Mapper')
      mapper = mapper_class.new(destination, options)

      sub_mappers.each do |sub_mapper|
        mapper.add_mapper(*sub_mapper)
      end

      @mappers << mapper
      mapper
    end

    def apply_to(subject)
      @mappers.each do |mapper|
        mapper.apply_to(subject)
      end
    end
  end
end
