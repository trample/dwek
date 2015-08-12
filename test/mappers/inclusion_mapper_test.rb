require 'test_helper'

class InclusionMapperTest < ActiveSupport::TestCase

  def test_required_options
    error = assert_raises ArgumentError do
      Dwek::Mappers::InclusionMapper.new(:dest)
    end
    assert_match 'attribute', error.message
    assert_match 'values', error.message
  end

  def test_value_from
    subject = Dwek::Subject.new('1')
    subject.set_attribute(:name, 'Kevin')

    mapper = Dwek::Mappers::InclusionMapper.new(:dest, attribute: :name, values: %w[foo bar])
    assert_not mapper.value_from(subject)

    mapper = Dwek::Mappers::InclusionMapper.new(:dest, attribute: :name, values: %w[Kevin])
    assert mapper.value_from(subject)
  end
end
