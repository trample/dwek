# $Id$

class Dwek::Parser
  rule
    mapping_list: mapping | mapping mapping_list
    mapping: 'map' STRING 'as' MAPPER linebreak_list { @mapper_list.add_mapper(*MapperProxy.new(val[1], val[3]).to_mapper) }
      | 'map' STRING 'as' MAPPER 'with' linebreak_list assignment_list { @mapper_list.add_mapper(*MapperProxy.new(val[1], val[3], val[6]).to_mapper) }
    assignment_list: assignment { result = [val[0]] }
      | assignment assignment_list { result = [val[0]] + val[1] }
    assignment: STRING ':' STRING linebreak_list { result = Assignment.new(val[0], val[2]) }
      | STRING ':' array linebreak_list { result = Assignment.new(val[0], val[2]) }
    linebreak_list: linebreak | linebreak linebreak_list
    linebreak: NEWLINE
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
    def initialize(destination, mapper_type, assignment_list = [])
      @destination = destination.to_sym
      @mapper_type = mapper_type.to_sym
      @options = {}

      assignment_list.each do |assignment|
        @options.merge!(assignment.to_h)
      end
    end

    def to_mapper
      [@destination, @mapper_type.to_sym, @options]
    end
  end

  class Assignment
    def initialize(key, value)
      @key = key
      @value = value
    end

    def to_h
      { @key.to_sym => @value }
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
        result << [:NEWLINE, nil]
        @current_line += 1
      when /\A\s+/
        # ignore non-newline whitespace
      when /\A\[(\w+)\]/
        result << [:MAPPER, $1]
      when /\A(?:map|as|with|:|\[|\]|\,)/
        result << [$&, nil]
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
