require 'test_helper'

class DirectMapperTest < ActiveSupport::TestCase

  def test_required_options
    error = assert_raises ArgumentError do
      Dwek::Mappers::DirectMapper.new(:dest)
    end
    assert_match 'form', error.message
    assert_match 'field', error.message
  end

  def test_value_from
    subject = Dwek::Subject.new('1')
    instance = Dwek::TempTable::Person.where(subject: '1').limit(1).to_a.first

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'person', field: 'firstname')
    assert_equal instance.firstname, mapper.value_from(subject)

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'person', field: 'lastname')
    assert_equal instance.lastname, mapper.value_from(subject)
  end
end
