module CurrencyCloud
  
  class UnexpectedError < StandardError
    attr_reader :inner_error

    def initialize(e)
      @inner_error = e
    end
  end
  
end