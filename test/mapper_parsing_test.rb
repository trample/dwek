require 'test_helper'

class MapperParsingTest < ActiveSupport::TestCase

  def test_parser
    parser = Dwek::Parser.new
    parser.parse(File.read('test/support/mapper_parsing.dwek'))

    subject = Dwek::Subject.new('1')
    parser.mapper_list.apply_to(subject)

    assert_equal 'Kevin', subject.get_attribute(:direct_first_name)
    assert_equal 'Kevin', subject.get_attribute(:copied_name)
    assert subject.get_attribute(:name_included)

    assert_equal 24, subject.get_attribute(:age)
    assert subject.get_attribute(:age_is_24)

    assert_equal "Kevin\n24", subject.get_attribute(:list)
  end
end
