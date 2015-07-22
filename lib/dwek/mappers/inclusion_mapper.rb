class Dwek::Mappers::InclusionMapper < Dwek::Mapper

  desc "checks whether '*attribute*' is included in the following list of values: *value_list*"
  required :value_list, :attribute

  def value_from(subject) #:nodoc:
    @options[:value_list].include?(subject.get_attribute(@options[:attribute]))
  end
end
