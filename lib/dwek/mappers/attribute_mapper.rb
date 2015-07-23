# maps one attribute onto another attribute
class Dwek::Mappers::AttributeMapper < Dwek::Mapper

  desc "the value of '*attribute*' set on the subject"
  required :attribute

  def value_from(subject) #:nodoc:
    subject.get_attribute(@options[:attribute])
  end
end
