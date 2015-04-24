module CurrencyCloud
  
  class ResponseHandler
    
    attr_reader :response
    
    def self.process(response)
      new(response).data
    end
    
    def initialize(response)
      @response = response
    end
    
    def data
      if success?
        return parsed_response
      else
        handle_failure
      end
    end
    
    private
    
    def success?
      [200, 202].include?(response.code)
    end
    
    def handle_failure
      case response.code
        when 400
          raise CurrencyCloud::BadRequestError.new(response)
        when 401
          raise CurrencyCloud::AuthenticationError.new(response)
        when 404
          raise CurrencyCloud::NotFoundError.new(response)
        else
          raise CurrencyCloud::UnexpectedError.new(response)
      end
    end
    
    def parsed_response
      @parsed_response ||= JSON.parse(response.body)
    end
    
  end
  
end
