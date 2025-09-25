module CurrencyCloud
  class PaymentValidationResult
    include CurrencyCloud::Resource
    attr_reader :response_headers

    def initialize(data, response_headers = {})
      super(data)
      @response_headers = response_headers
    end

    def to_yaml(options = {})
      # Only exclude @response_headers from serialization
      {
        'attributes' => @attributes,
        'changed_attributes' => @changed_attributes
      }.to_yaml(options)
    end
  end
end