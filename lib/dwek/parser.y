# $Id$
class Dwek::Parser
  prechigh
    left OPERATOR_LEVEL3
    left OPERATOR_LEVEL2
    left OPERATOR_LEVEL1
  preclow

  options no_result_var

  rule
    configuration: expression | expression configuration
    expression: assignment ';' | assignment_exp ';' | mapping ';' | print ';'

    assignment: VARIABLE '=' object { @variable_registry.set(val[0], val[2]) }
    assignment_exp: VARIABLE OPERATOR_ASSIGNMENT exp { @variable_registry.assign_set(val[0], val[1], val[2]) }

    mapping: 'MAP' object 'AS' MAPPER 'WITH' options_list { MapperFactory.build(val[1].to_sym, val[3].to_sym, val[5]).apply }
      | 'MAP' object 'AS' MAPPER 'INCLUDING' submapping_list { MapperFactory.build(val[1].to_sym, val[3].to_sym, {}, val[5]).apply }

    submapping_list: submapping { [val[0]] }
      | submapping ',' submapping_list { [val[0]] + val[2] }
    submapping: 'MAP' MAPPER 'WITH' options_list { [nil, val[1].to_sym, val[3]] }

    options_list: option
      | option 'AND' options_list { val[2].merge(val[0]) }
    option: OPTION '=' object { { val[0].to_sym => val[2] } }

    object: STRING | array | exp
    variable: VARIABLE { @variable_registry.get(val[0]) }

    exp: exp OPERATOR_LEVEL3 exp { val[0].send(val[1].to_sym, val[2]) }
      | exp OPERATOR_LEVEL2 exp { val[0].send(val[1].to_sym, val[2]) }
      | exp OPERATOR_LEVEL1 exp { val[0].send(val[1].to_sym, val[2]) }
      | '(' exp ')' { val[1] }
      | NUMBER | variable

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
    @lexer = Lexer.new(verbose: @verbose)
    @lexer.parse(string)

    do_parse
  end

  def next_token
    @lexer.next_token
  end
