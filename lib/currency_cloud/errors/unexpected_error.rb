module CurrencyCloud
  class UnexpectedError < StandardError
    include ErrorUtils

    attr_reader :inner_error

    def initialize(verb, route, params, e)
      @verb = verb
      @route = route
      @params = redacted_params(params)
      @inner_error = e
    end

    def to_s
      class_name = super

      string_params = Hash[@params.map { |k, v| [k.to_s, v.to_s] }]

      error_details = {
        'platform' => platform,
        'request' => {
          'parameters' => string_params,
          'verb' => @verb.to_s,
          'url' => @route
        },
        'inner_error' => inner_error.to_s
      }
      "#{class_name}#{$/}#{YAML.dump(error_details)}"
    end
  end
end
