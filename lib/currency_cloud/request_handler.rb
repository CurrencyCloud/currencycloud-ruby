module CurrencyCloud
  class RequestHandler
    attr_reader :session

    def initialize(session = CurrencyCloud.session)
      @session = session
    end

    def get(route, params = {}, opts = {})
      retry_authenticate('get', route, params, opts) do |url, new_params, options|
        options[:query] = new_params
        HTTParty.get(url, options)
      end
    end

    def post(route, params = {}, opts = {})
      retry_authenticate('post', route, params, opts) do |url, new_params, options|
        options[:body] = new_params
        HTTParty.post(url, options)
      end
    end

    private

    def retry_authenticate(verb, route, params, opts)
      should_retry = opts[:should_retry].nil? ? true : opts.delete(:should_retry)

      params = process_params(params)
      full_url = build_url(route)

      response = nil
      retry_count = should_retry ? 0 : 2
      while retry_count < 3
        options = process_options(opts)
        response = yield(full_url, params, options)
        break unless response.code == 401 && should_retry
        session.reauthenticate
        retry_count += 1
      end

      response_handler = CurrencyCloud::ResponseHandler.new(verb, full_url, params, response)
      response_handler.process
    rescue ApiError, UnexpectedError
      raise
    rescue => e
      raise UnexpectedError.new(verb, full_url, params, e)
    end

    def process_options(opts)
      options = { headers: headers }
      # options[:debug_output] = $stdout
      options.merge(opts)
      # options
    end

    def process_params(params)
      if session && session.on_behalf_of && CurrencyCloud::UUID_REGEX.match(session.on_behalf_of)
        params[:on_behalf_of] = session.on_behalf_of
      end

      params
    end

    def headers
      headers = {}
      headers['X-Auth-Token'] = session.token if session && session.token
      headers['User-Agent'] = user_agent
      headers
    end

    def build_url(route)
      "#{session.environment_url}/#{CurrencyCloud::API_VERSION}/" + route
    end

    def user_agent
      "CurrencyCloudSDK/2.0 Ruby/#{CurrencyCloud::VERSION}"
    end
  end
end
