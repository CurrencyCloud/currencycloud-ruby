module CurrencyCloud

  class RequestHandler
    
    attr_reader :session, :route, :options
    
    def initialize(session=nil)
      @session = session
    end
    
    def authenticate(environment, login_id, api_key)
      @route = 'authenticate/api'
      params = {:login_id => login_id, :api_key => api_key}
      @response = HTTParty.post(full_route(environment), :body => params)
      handle_response['auth_token'] # rescue errors?
    rescue => e
      raise e if e.class.ancestors.include?(CurrencyCloud::ApiError)
      raise UnexpectedError.new(e)
    end
    
    def get(route, params, opts={})
      @route = route
      @options = opts
      time_taken "to get: #{route}" do
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
      time_taken "to post: #{route}" do
        @response = HTTParty.post(full_route, {:body => params, :headers => { 'X-Auth-Token' => session.token}}.merge(opts))
      end
      handle_response
    rescue => e
      raise e if e.class.ancestors.include?(CurrencyCloud::ApiError)
      raise UnexpectedError.new(e)
    end

    private
    
    def time_taken(description)
      # TODO: --verbose mode?
      t1 = Time.now
      # puts "Going #{description}"
      yield if block_given?
      # puts "Took #{(Time.now - t1)} seconds #{description}"
    end
    
    def full_route(environment=nil)
      url_prefix(environment) + route
    end
    
    def url_prefix(environment=nil)
      if session
        "#{session_environment_url}/#{CurrencyCloud::ApiVersion}/"
      else
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
