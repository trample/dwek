require 'test_helper'

class VariableRegistryTest < ActiveSupport::TestCase

  def test_registry
    registry = Dwek::VariableRegistry.new
    registry.set(:name, 'Kevin')
    registry.set(:list, ['Kevin', 'Ezra', 'Maritza'])

    assert_equal 'Kevin', registry.get(:name)
    assert_equal ['Kevin', 'Ezra', 'Maritza'], registry.get(:list)
  end
end
