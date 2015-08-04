# $Id$
class Dwek::Parser
  options no_result_var
  rule
    configuration: expression | expression configuration
    expression: assignment ';' | mapping ';' | print ';'

    assignment: VARIABLE '=' object { @variable_registry.set(val[0], val[2]) }

    mapping: 'MAP' object 'AS' MAPPER  { @mapper_list.add_mapper(val[1].to_sym, val[3].to_sym) }
      | 'MAP' object 'AS' MAPPER 'WITH' options_list { @mapper_list.add_mapper(val[1].to_sym, val[3].to_sym, val[5]) }

    options_list: option
      | option 'AND' options_list { val[2].merge(val[0]) }
    option: OPTION '=' object { { val[0].to_sym => val[2] } }

    object: variable | STRING | array | NUMBER
    variable: VARIABLE { @variable_registry.get(val[0]) }

    array: '[' array_contents ']' { val[1] }
      | '[' ']' { [] }
    array_contents: object { [val[0]] }
      | array_contents ',' object { val[0] + [val[2]] }

    print: 'PRINT' object { puts val[1] }
end

---- header
# $Id$
require 'dwek/lexer'
require 'dwek/variable_registry'

---- inner
  attr_reader :mapper_list

  def initialize(verbose = false)
    @verbose = verbose
  end

  def parse(string)
    @variable_registry = VariableRegistry.new
    @mapper_list = MapperList.new

    @lexer = Lexer.new
    @lexer.parse(string)

    do_parse
  end

  def next_token
    @lexer.next_token
  end
