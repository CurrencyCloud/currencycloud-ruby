require 'spec_helper'
require 'net/http'

describe 'Session', :vcr => true do
  before(:each) do
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'rjnienaber@gmail.com'
    CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb65f02f129fd87eafa45ded8ae257528f0'
    CurrencyCloud.token = nil
  end

  after(:each) do
    CurrencyCloud.reset_session
  end

  describe 'can successfully' do
    it 'authenticate' do
      expect(CurrencyCloud.session).to_not be_nil
      expect(CurrencyCloud.session.token).to eq('af74248c0a70212610a3169eea8d3f3a')
    end
  
    it 'use just a token' do
      CurrencyCloud.login_id = nil
      CurrencyCloud.api_key = nil
      CurrencyCloud.token = '7fbba909f66ee6721b2e20a5fa1ccae7'

      response = CurrencyCloud::Beneficiary.find
      expect(response).to_not be_nil
    end

    it 'close a session' do
      CurrencyCloud.session 
      expect(CurrencyCloud.close_session).to eq(true)
    end

    it 'handles session timeout error' do
      CurrencyCloud.token = '3068d3ff160ab0636648d98b4e4e10ad'

      response = CurrencyCloud::Beneficiary.find
      expect(response).to_not be_nil
    end
  end

  describe 'handles common errors and' do
    it 'raises bad request on user error' do
      CurrencyCloud.login_id = 'non-existent-login-id'
      CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb57528f0'

      error = nil
      begin
        CurrencyCloud.session
        raise 'Should have failed'
      rescue CurrencyCloud::BadRequestError => error
      end

      expect(error.code).to eq('auth_invalid_user_login_details')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(400)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('api_key')
      expect(error_message.code).to eq('api_key_length_is_invalid')
      expect(error_message.message).to eq('api_key should be 64 character(s) long')
      expect(error_message.params).to include("length" => 64)
    end

    it 'raises authentication error on invalid details' do
      CurrencyCloud.login_id = 'non-existent-login-id'
      CurrencyCloud.api_key = 'efb5ae2af84978b7a37f18dd61c8bbe139b403009faea83484405a3dcb64c4d8'

      error = nil
      begin
        CurrencyCloud.session
        raise 'Should have failed'
      rescue CurrencyCloud::AuthenticationError => error
      end

      expect(error.code).to eq('auth_failed')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(401)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('username')
      expect(error_message.code).to eq('invalid_supplied_credentials')
      expect(error_message.message).to eq('Authentication failed with the supplied credentials')
      expect(error_message.params).to be_empty
    end

    it 'raises unexpected error on connection issue' do
      allow(HTTParty).to receive(:post).and_raise(Timeout::Error)

      error = nil
      begin
        CurrencyCloud.session
        raise 'Should have failed'
      rescue CurrencyCloud::UnexpectedError => error
      end

      expect(error.inner_error).to_not be_nil
      expect(error.inner_error.class).to eq(Timeout::Error)
    end

    it 'raises forbidden error on authorization failure' do
      error = nil
      begin
        CurrencyCloud.session
        raise 'Should have failed'
      rescue CurrencyCloud::ForbiddenError => error
      end

      expect(error.code).to eq('auth_failed')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(403)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('username')
      expect(error_message.code).to eq('invalid_supplied_credentials')
      expect(error_message.message).to eq('Authentication failed with the supplied credentials')
      expect(error_message.params).to be_empty
    end
    
    it 'raises internal server error on server error' do
      error = nil
      begin
        CurrencyCloud.session
        raise 'Should have failed'
      rescue CurrencyCloud::InternalApplicationError => error
      end

      expect(error.code).to eq('internal_application_error')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(500)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('base')
      expect(error_message.code).to eq('internal_application_error')
      expect(error_message.message).to eq('A general application error occurred')
      expect(error_message.params).to include("request_id" => 2771875643610572878)
    end
    
    it 'raises too many requests error when rate limited' do
      CurrencyCloud.login_id = 'rjnienaber@gmail.com2'

      error = nil
      begin
        CurrencyCloud.session
        
        raise 'Should have failed'
      rescue CurrencyCloud::TooManyRequestsError => error
      end

      expect(error.code).to eq('too_many_requests')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(429)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('base')
      expect(error_message.code).to eq('too_many_requests')
      expect(error_message.message).to eq('Too many requests have been made to the api. Please refer to the Developer Center for more information')
      expect(error_message.params).to be_empty
    end
  end
end