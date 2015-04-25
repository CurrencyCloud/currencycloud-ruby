module CurrencyCloud

  class RequestHandler
    
    attr_reader :session
    
    def initialize(session)
      @session = session
    end
    
    def get(route, params, opts={})
      retry_authenticate('get', route, params, opts) do |url|
        @response = HTTParty.get(url, {:query => params, :headers => headers}.merge(opts))
      end
    end
    
    def post(route, params, opts={})
      retry_authenticate('post', route, params, opts) do |url|
        HTTParty.post(url, {:body => params, :headers => headers}.merge(opts))
      end
    end

    private
    def retry_authenticate(verb, route, params, opts)
      should_retry = opts[:should_retry].nil? ? true : opts.delete(:should_retry)
      description = "to #{verb}: #{route}"

      response = nil
      retry_count = should_retry ? 0 : 2
      while retry_count < 3
        response = yield full_url(route)
        break unless response.code == 401 && should_retry
        session.token = nil
        session.authenticate
        retry_count += 1
      end
      
      process_response(response)
    rescue => e
      raise if e.class.ancestors.include?(ApiError) || e.is_a?(UnexpectedError)
      raise UnexpectedError.new(e)
    end

    def headers
      headers = {}
      headers['X-Auth-Token'] if session.token
      headers
    end
        
    def full_url(route)
      "#{session.environment_url}/#{CurrencyCloud::ApiVersion}/" + route
    end
    
    def process_response(response)
      CurrencyCloud::ResponseHandler.process(response)
    end
  end
end
