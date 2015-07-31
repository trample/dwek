module Dwek
  class Lexer

    def initialize(verbose = false)
      @verbose = verbose
      @tokens = []
    end

    def parse(string)
      until string.empty?
        skipped = false
        case string
        when /\A\/\*.*?\*\//m, /\A(?:\n|\s+|\/\/[^\n]+)/
          skipped = true
        when /\A(\d+)/
          @tokens << [:NUMBER, $1.to_i]
        when /\A\{(\w+)\}/
          @tokens << [:MAPPER, $1]
        when /\A(?:map|as|with|and|=|\[|\]|\,|;)/i
          @tokens << [$&.upcase, nil]
        when /\A@(\w+)/
          @tokens << [:VARIABLE, $1]
        when /\A(\w+)/
          @tokens << [:OPTION, $1]
        when /\A\'(\w+)\'/, /\A\"(\w+)\"/
          @tokens << [:STRING, $1]
        else
          raise SyntaxError, "can't parse #{string.first(10)}"
        end
        puts @tokens.last.inspect unless skipped || !@verbose
        string = $'
      end
      @tokens << [false, '$end']
    end

    def next_token
      @tokens.shift
    end
  end
end
