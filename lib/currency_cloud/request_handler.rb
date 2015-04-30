module CurrencyCloud

  class RequestHandler
    
    attr_reader :session
    
    def initialize(session = CurrencyCloud.session)
      @session = session
    end
    
    def get(route, params={}, opts={})
      retry_authenticate('get', route, params, opts) do |url, options|
        HTTParty.get(url, options)
      end
    end
    
    def post(route, params={}, opts={})
      retry_authenticate('post', route, params, opts) do |url, options|
        HTTParty.post(url, options)
      end
    end

    private
    def retry_authenticate(verb, route, params, opts)
      should_retry = opts[:should_retry].nil? ? true : opts.delete(:should_retry)
      
      options = process_options(verb, params, opts)
      full_url = build_url(route)

      response = nil
      retry_count = should_retry ? 0 : 2
      while retry_count < 3
        response = yield(full_url, options)
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

    def process_options(verb, params, opts)
      options = {:headers => headers }
      #TODO: should this be a symbol?
      params_key = verb == :get ? :query : :body
      options[params_key] = params
      options.merge!(opts)
      # options[:debug_output] = $stdout
      options
    end

    def headers
      headers = {}
      headers['X-Auth-Token'] = session.token if session && session.token
      headers
    end
        
    def build_url(route)
      "#{session.environment_url}/#{CurrencyCloud::ApiVersion}/" + route
    end
  end
end
