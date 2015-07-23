module Dwek
  class VariableRegistry
    def initialize
      @variables = {}
    end

    def get(key)
      @variables[key.to_sym]
    end

    def set(key, value)
      @variables[key.to_sym] = value
    end
  end
end
