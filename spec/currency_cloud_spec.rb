require 'spec_helper'

describe CurrencyCloud do

  before do
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
       .to raise_error(CurrencyCloud::GeneralError, "'' is not a valid environment, must be one of: production, demonstration, uat")
    end

    it "raises an error if the environment is invalid" do
      CurrencyCloud.environment = :invalid
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::GeneralError, "'invalid' is not a valid environment, must be one of: production, demonstration, uat")
    end

    it "raises an error if the login_id is not set" do
      CurrencyCloud.environment = :demonstration
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::GeneralError, "login_id must be set using CurrencyCloud.login_id=")
    end

    it "raises an error if the api_key is not set" do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.login_id = 'test@example.com'
      expect { CurrencyCloud.session }
       .to raise_error(CurrencyCloud::GeneralError, "api_key must be set using CurrencyCloud.api_key=")
    end
  end

  describe "#on_behalf_of" do
    before do
      CurrencyCloud.environment = :demonstration
      CurrencyCloud.token = '4df5b3e5882a412f148dcd08fa4e5b73'
      CurrencyCloud.session.on_behalf_of = nil
    end

    it "sets the value on the session, and removes it when done" do
      CurrencyCloud.on_behalf_of('c6ece846-6df1-461d-acaa-b42a6aa74045') do
        expect(CurrencyCloud.session.on_behalf_of).to eq('c6ece846-6df1-461d-acaa-b42a6aa74045')
      end
      expect(CurrencyCloud.session.on_behalf_of).to be_nil
    end

    it "still removes the value from the session on error" do
      expect do 
        CurrencyCloud.on_behalf_of('c6ece846-6df1-461d-acaa-b42a6aa74045') do
          expect(CurrencyCloud.session.on_behalf_of).to eq('c6ece846-6df1-461d-acaa-b42a6aa74045')
          raise 'Completed Expected error'
        end
      end.to raise_error('Completed Expected error')
      
      expect(CurrencyCloud.session.on_behalf_of).to be_nil
    end

    it 'prevents reentrant usage' do
      expect do
        CurrencyCloud.on_behalf_of('c6ece846-6df1-461d-acaa-b42a6aa74045') do
          CurrencyCloud.on_behalf_of('f57b2d33-652c-4589-a8ff-7762add2706d') do
            raise "Should raise exception"
          end
        end
      end.to raise_error(CurrencyCloud::GeneralError, "#on_behalf_of has already been set")
    end

    it 'prevents reentrant usage' do
      expect do
        CurrencyCloud.on_behalf_of('Richard Nienaber') do
          raise "Should raise exception"
        end
      end.to raise_error(CurrencyCloud::GeneralError, "contact id for on behalf of is not a UUID")
    end    
  end
end