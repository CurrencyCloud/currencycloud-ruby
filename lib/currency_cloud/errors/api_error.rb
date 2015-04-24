module CurrencyCloud
  class ApiErrorMessage
    attr_reader :field, :code, :message, :params

    def initialize(field, error)
      @field = field
      @code = error['code']
      @message = error['message']
      @params = error['params']
    end
  end


  class ApiError < StandardError
    attr_reader :code, :messages, :raw_response, :status_code

    def initialize(raw_response)
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
  end
end