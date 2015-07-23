module Dwek
  class Printer

    def initialize(subjects)
      @subjects = subjects
      @attributes = [:subject_id]
      @lengths = [:subject_id.to_s.length]

      subjects.first.attributes.keys.each do |attribute|
        @attributes << attribute
        @lengths << ([attribute.to_s.length] + subjects.map { |subject| subject.get_attribute(attribute).to_s.length }).max
      end
    end

    def print_table
      boundary
      print_row(@attributes)
      boundary
      @subjects.each do |subject|
        row = [subject.subject_id] + @attributes[1..-1].map do |attribute|
          subject.get_attribute(attribute)
        end
        print_row(row)
      end
      boundary
    end

    private

      def boundary
        @lengths.each do |length|
          print '+' + ('-' * (length + 2))
        end
        puts '+'
      end

      def print_row(attributes)
        attributes.each_with_index do |attribute, index|
          print "| #{attribute}"
          print ' ' * (@lengths[index] - attribute.to_s.length + 1)
        end
        puts '|'
      end
  end
end
