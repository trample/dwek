require 'test_helper'

DWEK = <<-DWEK
map 'email' as {direct} with form = 'person' and field = 'email';
map 'first_name' as {direct} with form = 'person' and field = 'firstname';
map 'last_name' as {direct} with form = 'person' and field = 'lastname';
DWEK

class MapperParsingTest < ActiveSupport::TestCase

  def setup
    Dwek::Subject.table.update_all(mapped_attributes: nil)
  end

  def test_parser
    parser = Dwek::Parser.new
    parser.parse(DWEK)

    subject = Dwek::Subject.new('1')
    instance = Dwek::TempTable::Person.where(subject: '1').limit(1).to_a.first
    assert_equal instance.email, subject.get_attribute(:email)
  end
end
