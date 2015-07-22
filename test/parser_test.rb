require 'test_helper'

class ParserTest < ActiveSupport::TestCase

  def test_parser
    parser = Dwek::Parser.new
    parser.parse(File.read('test/test_input.dwek'))

    subject = Dwek::Subject.new('1')
    parser.mapper_list.apply_to(subject)

    assert_equal 'Kevin', subject.get_attribute(:direct_first_name)
    assert_equal 'Kevin', subject.get_attribute(:copied_name)
    assert subject.get_attribute(:name_included)
  end
end
