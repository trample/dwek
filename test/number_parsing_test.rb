require 'test_helper'

class NumberParsingTest < ActiveSupport::TestCase

  def test_addition
    assert_equal 10, test_arithmetic('5 + 5')
    assert_equal 10, test_assignment_arithmetic(5, '+= 5')
  end

  def test_subtraction
    assert_equal 0, test_arithmetic('5 - 5')
    assert_equal 0, test_assignment_arithmetic(5, '-= 5')
  end

  def test_multiplication
    assert_equal 25, test_arithmetic('5 * 5')
    assert_equal 25, test_assignment_arithmetic(5, '*= 5')
  end

  def test_division
    assert_equal 1, test_arithmetic('5 / 5')
    assert_equal 1, test_assignment_arithmetic(5, '/= 5')
  end

  def test_mod
    assert_equal 1, test_arithmetic('6 % 5')
    assert_equal 1, test_assignment_arithmetic(6, '%= 5')
  end

  def test_power
    assert_equal 3125, test_arithmetic('5 ** 5')
    assert_equal 3125, test_assignment_arithmetic(5, '**= 5')
  end

  def test_operator_precedence
    assert_equal 10, test_arithmetic('5 + 5 - 5 * 5 / 5 ** 5')
    assert_equal 5, test_arithmetic('5 - 5 / 5 ** 5')
    assert_equal 5, test_arithmetic('5 + 5 % 5')
  end

  private

    # capture the output from the block
    def capture_output(&block)
      out = StringIO.new
      $stdout = out
      yield
      out.string
    ensure
      $stdout = STDOUT
    end

    # test some basic arithmetic
    def test_arithmetic(arithmetic)
      parser = Dwek::Parser.new
      output = capture_output do
        parser.parse("PRINT #{arithmetic};")
      end
      output.split.first.to_i
    end

    # test some basic assignment arithmetic
    def test_assignment_arithmetic(base, arithmetic)
      parser = Dwek::Parser.new
      output = capture_output do
        parser.parse("@x = #{base}; @x #{arithmetic}; PRINT @x;")
      end
      output.split.first.to_i
    end
end
