require 'test_helper'

class AttributeMapperTest < ActiveSupport::TestCase

  def test_required_options
    error = assert_raises ArgumentError do
      Dwek::Mappers::AttributeMapper.new(:dest)
    end
    assert_match 'attribute', error.message
  end

  def test_value_from
    subject = Dwek::Subject.new('1', name: 'Kevin')
    mapper = Dwek::Mappers::AttributeMapper.new(:dest, attribute: :name)
    assert_equal 'Kevin', mapper.value_from(subject)
  end
end
