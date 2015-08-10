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

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'names', field: 'first_name')
    assert_equal 'Kevin', mapper.value_from(subject)

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'roles', field: 'title')
    assert_nil mapper.value_from(subject)
  end
end
