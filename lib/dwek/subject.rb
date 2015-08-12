module Dwek
  class Subject

    attr_accessor :instance, :subject_id

    def initialize(subject_id)
      self.subject_id = subject_id
      self.instance = self.class.table.find_or_initialize_by(id: subject_id)
    end

    def get_records_for(form_name)
      Form.cache[form_name].get(subject_id)
    end

    def get_attribute(attribute)
      instance.mapped_attributes[attribute.to_sym]
    end

    def mapped_attributes
      self.instance.mapped_attributes
    end

    def set_attribute(attribute, value)
      instance.mapped_attributes ||= {}
      instance.mapped_attributes[attribute] = value
      instance.save
    end

    class << self
      def apply(mapper)
        table.ids.each do |subject_id|
          mapper.apply_to(new(subject_id))
        end
      end

      def init_from(subject_ids)
        table.transaction do
          subject_ids.each do |subject_id|
            table.create!(id: subject_id)
          end
        end
      end

      def table
        Dwek::TempTable::Subject
      end
    end
  end
end
