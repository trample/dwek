module Dwek
  class Lexer

    # build a new lexer and store the verbose setting
    def initialize(verbose: false)
      @verbose = verbose
      @tokens = []
    end

    # parse the given string of input
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
        when individual_tokens
          @tokens << [$&.upcase, nil]
        when /\A@(\w+)/
          @tokens << [:VARIABLE, $1]
        when /\A(\w+)/
          @tokens << [:OPTION, $1]
        when /\A\'(\w+)\'/, /\A\"(\w+)\"/
          @tokens << [:STRING, $1]
        when /\A((?:[\+\-\*\/\%]|\*\*)\=)/
          @tokens << [:OPERATOR_ASSIGNMENT, $1]
        when /\A([\*\/])/
          @tokens << [:OPERATOR_LEVEL2, $1]
        when /\A([\+\-])/
          @tokens << [:OPERATOR_LEVEL1, $1]
        else
          raise SyntaxError, "can't parse #{string.first(10)}"
        end
        puts @tokens.last.inspect unless skipped || !@verbose
        string = $'
      end
      @tokens << [false, '$end']
    end

    # shift off the next token
    def next_token
      @tokens.shift
    end

    private

      # the tokens that are not identified by a constant
      def individual_tokens
        @individual_tokens ||= begin
          tokens = (keyword_tokens + punctuation_tokens).map { |token| Regexp.escape(token) }
          /\A(?:#{tokens.join('|')})/i.freeze
        end
      end

      # the keywords used by the language
      def keyword_tokens
        %w{ map as with and print }
      end

      # the punctuation tokens used by the language
      def punctuation_tokens
        %w{ [ ] , ; ( ) = }
      end
  end
end
