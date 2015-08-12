# returns true or false if the given attribute is in the given list of values
class Dwek::Mappers::InclusionMapper < Dwek::Mapper

  desc "checks whether '*attribute*' is included in the following list of values: *values*"
  required :values, :attribute

  def value_from(subject) #:nodoc:
    options[:values].include?(subject.get_attribute(options[:attribute]))
  end
end
