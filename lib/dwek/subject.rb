module Dwek
  class Subject

    attr_reader :attributes, :subject_id

    def initialize(subject_id, attributes = {})
      @subject_id = subject_id
      @attributes = attributes
      @form_records = {}
    end

    def get_records_for(form_name)
      Form.cache[form_name].get(@subject_id)
    end

    def get_attribute(attribute)
      @attributes[attribute.to_sym]
    end

    def set_attribute(attribute, value)
      @attributes[attribute] = value
    end
  end
end
