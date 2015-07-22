class Dwek::Mappers::DirectMapper < Dwek::Mapper

  desc "a direct mapping from the '*form_name*' form's '*form_field*' field"
  required :form_name, :form_field

  def value_from(subject) #:nodoc:
    record = subject.get_records_for(@options[:form_name]).first
    record[@options[:form_field].to_sym] if record
  end
end
