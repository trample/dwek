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
    subject = Dwek::Subject.new('0201004')

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'dem', field: 'age_c')
    assert_equal '56', mapper.value_from(subject)

    mapper = Dwek::Mappers::DirectMapper.new(:dest, form: 'dem', field: 'sex')
    assert_equal '1', mapper.value_from(subject)
  end
end
