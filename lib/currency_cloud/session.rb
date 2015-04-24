module CurrencyCloud    

  class Session
    
    Environments = { :production => 'https://api.thecurrencycloud.com',
                     :demonstration => 'https://devapi.thecurrencycloud.com',
                     :uat => 'https://api-uat1.ccycloud.com'}
   
    attr_reader :environment, :login_id, :api_key
    attr_accessor :token
    
    def self.validate_environment(environment)
      unless Environments.keys.include?(environment)
        raise CurrencyCloud::ConfigError, "'#{environment}' is not a valid environment, must be one of: #{Environments.keys.join(", ")}"
      end
    end
   
    def initialize(environment, login_id, api_key, token)
      @environment = environment
      @login_id = login_id
      @api_key = api_key
      @token = token || authenticate
    end
    
    def environment_url
      Environments[environment]
    end
    
    private
    
    def authenticate
      validate
      request_handler.authenticate(environment, login_id, api_key)
    end
    
    def validate
      self.class.validate_environment(environment)
      raise CurrencyCloud::ConfigError, "login_id must be set using CurrencyCloud.login_id=" unless login_id
      raise CurrencyCloud::ConfigError, "api_key must be set using CurrencyCloud.api_key=" unless api_key
    end
    
    def request_handler
      RequestHandler.new
    end
    
  end
  
end