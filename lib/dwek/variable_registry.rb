module Dwek
  # the registry of all variables in the scope of a given configuration
  class VariableRegistry

    # initialize a list of variables
    def initialize
      @variables = {}
    end

    # retrieve the variable signified by the given key
    def get(key)
      @variables[key.to_sym]
    end

    # cache the value at the given key
    def set(key, value)
      @variables[key.to_sym] = value
    end

    #method for assignment operators such as +=
    def assign_set(key, operator, value)
      operator = operator[0...operator.index('=')].to_sym
      self.set(key, self.get(key).send(operator, value))
    end
  end
end
