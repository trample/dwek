# $Id$
class Dwek::Parser
  rule
    configuration: expression | expression configuration
    expression: assignment ';' | mapping ';'

    assignment: VARIABLE '=' object { @variable_registry.set(val[0], val[2]) }

    mapping: 'MAP' object 'AS' MAPPER  { @mapper_list.add_mapper(val[1].to_sym, val[3].to_sym) }
      | 'MAP' object 'AS' MAPPER 'WITH' options_list { @mapper_list.add_mapper(val[1].to_sym, val[3].to_sym, val[5]) }

    options_list: option
      | option 'AND' options_list { result = val[2].merge(val[0]) }
    option: OPTION '=' object { result = { val[0].to_sym => val[2] } }

    object: variable | STRING | array
    variable: VARIABLE { result = @variable_registry.get(val[0]) }

    array: '[' array_contents ']' { result = val[1] }
      | '[' ']' { result = [] }
    array_contents: object { result = [val[0]] }
      | array_contents ',' object { result = val[0] + [val[2]] }
end

---- header
# $Id$
require 'dwek/variable_registry'

---- inner
  attr_accessor :mapper_list

  def initialize(verbose = false)
    @verbose = verbose
  end

  def parse(string)
    @variable_registry = VariableRegistry.new
    @mapper_list = MapperList.new
    @current_line = 1

    @tokens = make_tokens(string)
    do_parse
  end

  def make_tokens(string)
    result = []
    until string.empty?
      skipped = false
      case string
      when /\A\/\*.*?\*\//m, /\A(?:\n|\s+|\/\/[^\n]+)/
        skipped = true
      when /\A\{(\w+)\}/
        result << [:MAPPER, $1]
      when /\A(?:map|as|with|and|=|\[|\]|\,|;)/i
        result << [$&.upcase, nil]
      when /\A@(\w+)/
        result << [:VARIABLE, $1]
      when /\A(\w+)/
        result << [:OPTION, $1]
      when /\A\'(\w+)\'/, /\A\"(\w+)\"/
        result << [:STRING, $1]
      else
        raise SyntaxError, "can't parse #{string.first(10)}"
      end
      puts result.last.inspect unless skipped || !@verbose
      string = $'
    end
    result << [false, '$end']
    result
  end

  def next_token
    @tokens.shift
  end
