module CurrencyCloud
  class ApiErrorMessage

    attr_reader :field, :code, :message, :params

    def initialize(field, error)
      @field = field
      @code = error['code']
      @message = error['message']
      @params = error['params']
    end

    def to_h
      {
        'field' => field,
        'code' => code,
        'message' => message,
        'params' => params
      }
    end
  end

  class ApiError < StandardError
    include ErrorUtils

    attr_reader :code, :messages, :raw_response, :status_code

    def initialize(verb, route, params, raw_response)
      @verb = verb
      @route = route
      @params = params
      @raw_response = raw_response
      @status_code = raw_response.code
      errors = raw_response.parsed_response
      @code = errors['error_code']
      @messages = []

      errors['error_messages'].each do |field, messages|
        messages.each do |message|
          @messages << ApiErrorMessage.new(field, message)
        end
      end
    end

    def to_s
      class_name = super

      string_params = Hash[@params.map { |k, v| [k.to_s, v.to_s]}]

      error_details = {
        'platform' => platform,
        'request' => {
          'parameters' => string_params,
          'verb' => @verb.to_s,
          'url' => @route
        },
        'response' => {
          'status_code' => status_code,
          'date' => raw_response.headers['Date'],
          'request_id' => (raw_response.headers['x-request-id'] || 0).to_i
        },
        'errors' => messages.map(&:to_h)
      }
      "#{class_name}#{$/}#{YAML.dump(error_details)}"
    end
  end

  class BadRequestError < ApiError; end
  class AuthenticationError < ApiError; end
  class ForbiddenError < ApiError; end
  class TooManyRequestsError < ApiError; end
  class InternalApplicationError < ApiError; end
  class NotFoundError < ApiError; end
end