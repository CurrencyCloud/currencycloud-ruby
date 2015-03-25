module CurrencyCloud    

  class Session
    
    Environments = { :production => 'https://api.thecurrencycloud.com',
                     :demonstration => 'https://devapi.thecurrencycloud.com',
                     :uat => 'https://api-uat1.ccycloud.com',
                     :test => 'http://localhost:36006' }
   
    attr_reader :environment, :login_id, :api_key
    attr_reader :token
    
    def self.validate_environment(environment)
      unless Environments.keys.include?(environment)
        raise CurrencyCloud::AuthenticationError, "'#{environment}' is not a valid environment, must be one of: #{Environments.keys.join(", ")}"
      end
    end
   
    def initialize(environment, login_id, api_key)
      @environment = environment
      @login_id = login_id
      @api_key = api_key
      authenticate
    end
    
    def environment_url
      Environments[environment]
    end
    
    private
    
    def authenticate
      validate
      @token = request_handler.authenticate(environment, login_id, api_key)
    end
    
    def validate
      self.class.validate_environment(environment)
      raise CurrencyCloud::AuthenticationError, "login_id must be set using CurrencyCloud.login_id=" unless login_id
      raise CurrencyCloud::AuthenticationError, "api_key must be set using CurrencyCloud.api_key=" unless api_key
    end
    
    def request_handler
      RequestHandler.new
    end
    
  end
  
end