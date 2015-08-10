require 'test_helper'

DWEK = <<-DWEK
map 'dem_birthdat' as {direct} with form = 'dem' and field = 'birthdat';
map 'dem_sex' as {direct} with form = 'dem' and field = 'sex';
DWEK

class MapperParsingTest < ActiveSupport::TestCase

  def test_parser
    parser = Dwek::Parser.new
    parser.parse(DWEK)

    subject = Dwek::Subject.new('0201009')
    assert_equal '1939-04-28', subject.get_attribute(:dem_birthdat)
  end
end
