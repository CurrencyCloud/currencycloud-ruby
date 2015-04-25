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
      error_class = case response.code
        when 400 then CurrencyCloud::BadRequestError
        when 401 then CurrencyCloud::AuthenticationError
        when 403 then CurrencyCloud::ForbiddenError
        when 404 then CurrencyCloud::NotFoundError
        when 429 then CurrencyCloud::TooManyRequestsError
        when 500 then CurrencyCloud::InternalApplicationError
        else CurrencyCloud::UnexpectedError
      end
      raise error_class.new(response)
    end
    
    def parsed_response
      @parsed_response ||= JSON.parse(response.body)
    end
  end
end
