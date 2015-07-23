# $Id$

class Dwek::Parser
  rule
    configuration: expression | expression configuration
    expression: mapping ';'

    mapping: 'MAP' STRING 'AS' MAPPER  { @mapper_list.add_mapper(*MapperProxy.new(val[1], val[3]).to_mapper) }
      | 'MAP' STRING 'AS' MAPPER 'WITH' assignment_list { @mapper_list.add_mapper(*MapperProxy.new(val[1], val[3], val[5]).to_mapper) }

    assignment_list: assignment
      | assignment 'AND' assignment_list { result = val[2].merge(val[0]) }
    assignment: OPTION '=' assignment_value { result = { val[0].to_sym => val[2] } }
    assignment_value: STRING | array

    array: '[' array_contents ']' { result = val[1] }
      | '[' ']' { result = [] }
    array_contents: STRING { result = [val[0]] }
      | array_contents ',' STRING { result = val[0] + [val[2]] }
end

---- header
# $Id$
---- inner
  attr_accessor :mapper_list

  class MapperProxy
    def initialize(destination, mapper_type, options = {})
      @destination = destination.to_sym
      @mapper_type = mapper_type.to_sym
      @options = options
    end

    def to_mapper
      [@destination, @mapper_type.to_sym, @options]
    end
  end

  def parse(string)
    @mapper_list = MapperList.new
    @current_line = 1

    @tokens = make_tokens(string)
    do_parse
  end

  def make_tokens(string)
    result = []
    until string.empty?
      case string
      when /\A(?:\r\n|\r|\n)/
        @current_line += 1
      when /\A\s+/
        # ignore non-newline whitespace
      when /\A#[^\r\n|\r|\n]+/
        # comments are ignored
      when /\A\{(\w+)\}/
        result << [:MAPPER, $1]
      when /\A(?:map|as|with|and|=|\[|\]|\,|;)/i
        result << [$&.upcase, nil]
      when /\A(\w+)/
        result << [:OPTION, $1]
      when /\A\'(\w+)\'/, /\A\"(\w+)\"/
        result << [:STRING, $1]
      else
        raise SyntaxError, "line #{@current_line}"
      end
      string = $'
    end
    result << [false, '$end']
    result
  end

  def next_token
    @tokens.shift
  end
