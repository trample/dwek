require 'test_helper'

class ParserTest < ActiveSupport::TestCase

  def test_parser
    parser = Dwek::Parser.new
    parser.parse(File.read('test/support/mapping_parsing.dwek'))

    subject = Dwek::Subject.new('1')
    parser.mapper_list.apply_to(subject)

    assert_equal 'Kevin', subject.get_attribute(:direct_first_name)
    assert_equal 'Kevin', subject.get_attribute(:copied_name)
    assert subject.get_attribute(:name_included)

    assert_equal 24, subject.get_attribute(:age)
    assert subject.get_attribute(:age_is_24)
  end

  def test_number_parsing
    parser = Dwek::Parser.new
    output = capture_output do
      parser.parse(File.read('test/support/number_parsing.dwek'))
    end
    assert_equal [55, 0, 25, 1, 10, 5, 25, 5, 0, 9], output.split.map(&:to_i)
  end

  private

    # capture the output from the block
    def capture_output(&block)
      out = StringIO.new
      $stdout = out
      yield
      out.string
    ensure
      $stdout = STDOUT
    end
end
