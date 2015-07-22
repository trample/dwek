require 'test_helper'

class InclusionMapperTest < ActiveSupport::TestCase

  def test_required_options
    error = assert_raises ArgumentError do
      Dwek::Mappers::InclusionMapper.new(:name)
    end
    assert_match 'attribute', error.message
    assert_match 'value_list', error.message
  end

  def test_value_from
    subject = Dwek::Subject.new('1', name: 'Kevin')

    mapper = Dwek::Mappers::InclusionMapper.new(:name, attribute: :name, value_list: %w[foo bar])
    assert_not mapper.value_from(subject)

    mapper = Dwek::Mappers::InclusionMapper.new(:name, attribute: :name, value_list: %w[Kevin])
    assert mapper.value_from(subject)
  end
end
