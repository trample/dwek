# directly maps from a given form and field
class Dwek::Mappers::DirectMapper < Dwek::Mapper

  desc "a direct mapping from the '*form*' form's '*field*' field"
  required :form, :field

  def value_from(subject) #:nodoc:
    record = subject.get_records_for(options[:form]).limit(1).to_a.first
    record[options[:field].to_sym] if record
  end
end
