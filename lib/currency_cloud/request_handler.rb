module CurrencyCloud

  class RequestHandler
    
    attr_reader :session, :route, :options
    
    def initialize(session)
      @session = session
    end
    
    def authenticate(login_id, api_key)
      @route = 'authenticate/api'
      params = {:login_id => login_id, :api_key => api_key}
      @response = HTTParty.post(full_route, :body => params)
      handle_response['auth_token'] # rescue errors?
    rescue => e
      raise e if e.class.ancestors.include?(CurrencyCloud::ApiError)
      raise UnexpectedError.new(e)
    end

    def get(route, params, opts={})
      @route = route
      @options = opts
      retry_authenticate "to get: #{route}" do
        @response = HTTParty.get(full_route, {:query => params, :headers => { 'X-Auth-Token' => session.token}}.merge(opts))
      end
      handle_response
    rescue => e
      raise e if e.class.ancestors.include?(CurrencyCloud::ApiError)
      raise UnexpectedError.new(e)
    end
    
    def post(route, params, opts={})
      @route = route
      @options = opts
      retry_authenticate "to post: #{route}" do
        @response = HTTParty.post(full_route, {:body => params, :headers => { 'X-Auth-Token' => session.token}}.merge(opts))
      end
      handle_response
    rescue => e
      raise e if e.class.ancestors.include?(CurrencyCloud::ApiError)
      raise UnexpectedError.new(e)
    end

    private
    
    def retry_authenticate(description)
      return unless block_given?
      retry_count = 0
      while retry_count < 3
        response = yield
        break unless response.code == 401
        session.token = nil
        session.send(:authenticate)
        retry_count += 1
      end
      response
    end
    
    def full_route
      url_prefix + route
    end
    
    def url_prefix
      if session
        "#{session_environment_url}/#{CurrencyCloud::ApiVersion}/"
      else
        environment = session.environment
        CurrencyCloud::Session.validate_environment(environment)
        "#{CurrencyCloud::Session::Environments[environment]}/#{CurrencyCloud::ApiVersion}/"
      end
    end
    
    def session_environment_url
      session.environment_url
    end
    
    def handle_response
      CurrencyCloud::ResponseHandler.process(@response)
    end
    
  end

end
