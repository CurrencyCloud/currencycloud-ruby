module CurrencyCloud
  class Session
    ENVIRONMENTS = {
      production: 'https://api.currencycloud.com',
      demonstration: 'https://devapi.currencycloud.com',
      uat: 'https://api-uat1.ccycloud.com'
    }.freeze

    attr_reader :environment, :login_id, :api_key
    attr_accessor :token

    # Stored fiber-local so the shared session can't leak contact context across threads.
    def on_behalf_of
      Thread.current[obo_key]
    end

    def on_behalf_of=(value)
      Thread.current[obo_key] = value
    end

    def self.validate_environment(environment)
      return if ENVIRONMENTS.key?(environment)
      raise "'#{environment}' is not a valid environment. Must be one of: #{ENVIRONMENTS.keys.join(', ')}"
    end

    def initialize(environment, login_id, api_key, token)
      @environment = environment
      @login_id = login_id
      @api_key = api_key

      if token
        self.class.validate_environment(environment)
        @token = token
      else
        authenticate
      end
    end

    def environment_url
      ENVIRONMENTS[environment]
    end

    def close
      request.post('authenticate/close_session')
    end

    def authenticate
      validate
      params = { login_id: login_id, api_key: api_key }
      CurrencyCloud.token = @token = request.post('authenticate/api', params, should_retry: false)['auth_token']
    end

    def reauthenticate
      CurrencyCloud.token = @token = nil
      authenticate
    end

    private

    def obo_key
      @obo_key ||= :"cc_on_behalf_of_#{object_id}"
    end

    def validate
      self.class.validate_environment(environment)
      raise CurrencyCloud::GeneralError, 'login_id must be set using CurrencyCloud.login_id=' unless login_id
      raise CurrencyCloud::GeneralError, 'api_key must be set using CurrencyCloud.api_key=' unless api_key
    end

    def request
      RequestHandler.new(self)
    end
  end
end
