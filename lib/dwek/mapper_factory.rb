module Dwek
  module MapperFactory

    def self.build(destination, mapper_type, options, sub_mappers = [])
      mapper_class = Mappers.const_get(mapper_type.to_s.capitalize + 'Mapper')
      mapper = mapper_class.new(destination, options)

      (sub_mappers || []).each do |sub_mapper|
        mapper.add_mapper(*sub_mapper)
      end

      mapper
    end
  end
end
