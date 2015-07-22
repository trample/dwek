module Dwek
  class Mapper

    attr_reader :destination, :options, :mapper_list
    delegate :add_mapper, to: :@mapper_list

    def initialize(destination, options = {})
      @destination = destination
      @options = options
      @mapper_list = MapperList.new

      if (missing_options = self.class.required_options - options.keys).any?
        raise ArgumentError, "Missing required options: #{missing_options.map(&:to_s).join(', ') } for #{self.class.name}"
      end
    end

    def apply_to(subject)
      value = self.value_from(subject)
      subject.set_attribute(@destination, value)
    end

    class << self
      attr_reader :description

      def desc(description)
        @description = description
      end

      def required(*options)
        @required_options = options
      end

      def required_options
        @required_options ||= []
      end
    end

    private

      def submappers
        @mapper_list.mappers
      end
  end
end
