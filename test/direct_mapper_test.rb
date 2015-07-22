require 'test_helper'

class DirectMapperTest < ActiveSupport::TestCase

  def test_required_options
    error = assert_raises ArgumentError do
      Dwek::Mappers::DirectMapper.new(:name)
    end
    assert_match 'form_name', error.message
    assert_match 'form_field', error.message
  end

  def test_value_from
    subject = Dwek::Subject.new('1')

    mapper = Dwek::Mappers::DirectMapper.new(:name, form_name: 'names', form_field: 'first_name')
    assert_equal 'Kevin', mapper.value_from(subject)

    mapper = Dwek::Mappers::DirectMapper.new(:name, form_name: 'roles', form_field: 'title')
    assert_nil mapper.value_from(subject)
  end
end
