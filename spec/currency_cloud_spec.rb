require 'spec_helper'

describe CurrencyCloud do

  before(:each) do
    CurrencyCloud.environment = nil
    CurrencyCloud.login_id = nil
    CurrencyCloud.api_key = nil
    CurrencyCloud.reset_session
  end

  describe "#environment" do

    it "can set the environment" do
      CurrencyCloud.environment = :development
      expect(CurrencyCloud.environment).to eq(:development)
    end

  end

  describe "#login_id" do

    it "can set the login_id" do
      CurrencyCloud.login_id = 'test@example.com'
      expect(CurrencyCloud.login_id).to eq('test@example.com')
    end

  end

  describe "#api_key" do

    it "can set the api_key" do
      CurrencyCloud.api_key = 'e3b0d6895f91f46d9eaf5c95aa0f64dca9007b7ab0778721b6cdc0a8bc7c563b'
      expect(CurrencyCloud.api_key).to eq('e3b0d6895f91f46d9eaf5c95aa0f64dca9007b7ab0778721b6cdc0a8bc7c563b')
    end

  end

  describe "#session" do

    it "returns a session object" do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.login_id = 'test@example.com'
      CurrencyCloud.api_key = 'e3b0d6895f91f46d9eaf5c95aa0f64dca9007b7ab0778721b6cdc0a8bc7c563b'

      request_handler = double('RequestHandler')
      expect(request_handler).to receive(:post).and_return({'auth_token' => '123'})
      expect(CurrencyCloud::RequestHandler).to receive(:new).and_return(request_handler)

      expect(CurrencyCloud.session).to be_a(CurrencyCloud::Session)
    end

    it "raises an error if the environment is not set" do
      CurrencyCloud.environment = nil
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::ConfigError, "'' is not a valid environment, must be one of: production, demonstration, uat")
    end

    it "raises an error if the environment is invalid" do
      CurrencyCloud.environment = :invalid
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::ConfigError, "'invalid' is not a valid environment, must be one of: production, demonstration, uat")
    end

    it "raises an error if the login_id is not set" do
      CurrencyCloud.environment = :demonstration
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::ConfigError, "login_id must be set using CurrencyCloud.login_id=")
    end

    it "raises an error if the api_key is not set" do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.login_id = 'test@example.com'
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::ConfigError, "api_key must be set using CurrencyCloud.api_key=")
    end

  end

  describe "#request" do

    it "calls the RequestHandler when issuing a get request" do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.login_id = 'test@example.com'
      CurrencyCloud.api_key = 'e3b0d6895f91f46d9eaf5c95aa0f64dca9007b7ab0778721b6cdc0a8bc7c563b'

      expect(CurrencyCloud::Session).to receive(:new).and_return(double('Session'))

      request_handler = double('RequestHandler')
      expect(request_handler).to receive(:get)
      expect(CurrencyCloud::RequestHandler).to receive(:new).and_return(request_handler)

      CurrencyCloud.request(:get, 'conversions/find', {})
    end

    it "calls the RequestHandler when issuing a post request" do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.login_id = 'test@example.com'
      CurrencyCloud.api_key = 'e3b0d6895f91f46d9eaf5c95aa0f64dca9007b7ab0778721b6cdc0a8bc7c563b'

      expect(CurrencyCloud::Session).to receive(:new).and_return(double('Session'))

      request_handler = double('RequestHandler')
      expect(request_handler).to receive(:post)
      expect(CurrencyCloud::RequestHandler).to receive(:new).and_return(request_handler)

      CurrencyCloud.request(:post, 'conversions/create', {})
    end

    it "raises an error if it cannot create a session" do
      CurrencyCloud.environment = :invalid
      expect { CurrencyCloud.request(:post, 'conversions/create', {}) }
       .to raise_error(CurrencyCloud::ConfigError, "'invalid' is not a valid environment, must be one of: production, demonstration, uat")
    end
    
  end
  
end