module CurrencyCloud
  class ResponseHandler
    attr_reader :verb, :route, :params, :response

    def initialize(verb, route, params, response)
      @verb = verb
      @route = route
      @params = params
      @response = response
    end

    def process
      return parsed_response if success?
      handle_failure
    end

    private

    def success?
      [200, 202].include?(response.code)
    end

    def handle_failure
      error_class = case response.code
                    when 400 then BadRequestError
                    when 401 then AuthenticationError
                    when 403 then ForbiddenError
                    when 404 then NotFoundError
                    when 429 then TooManyRequestsError
                    when 500 then InternalApplicationError
                    end

      raise error_class.new(verb, route, params, response) if error_class
      raise UnexpectedError.new(verb, route, params, response)
    end

    def parsed_response
      @parsed_response ||= JSON.parse(response.body)
    end
  end
end
