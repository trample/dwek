# returns a newline-separated list of the submappers' values
class Dwek::Mappers::ConcatMapper < Dwek::Mapper

  desc 'a concatenated list of:'

  def value_from(subject) #:nodoc:
    submappers.map { |mapper| mapper.value_from(subject) }.compact.join("\n")
  end
end
