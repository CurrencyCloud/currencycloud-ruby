require 'spec_helper'
require 'net/http'

describe 'Error', vcr: true do
  include CurrencyCloud::ErrorUtils

  before(:each) do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'rjnienaber@gmail.com'
    CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb65f02f129fd87eafa45ded8ae257528f0'
    CurrencyCloud.token = nil
  end

  it 'contains full details for api error' do
    CurrencyCloud.login_id = 'non-existent-login-id'
    CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb57528f0'

    expected_error = %{CurrencyCloud::BadRequestError
---
platform: #{platform}
request:
  parameters:
    login_id: REDACTED
    api_key: REDACTED
  verb: post
  url: https://devapi.currencycloud.com/v2/authenticate/api
response:
  status_code: 400
  date: Wed, 29 Apr 2015 22:46:53 GMT
  request_id: 2775253392756800903
errors:
- field: api_key
  code: api_key_length_is_invalid
  message: api_key should be 64 character(s) long
  params:
    length: 64
}

    expect { CurrencyCloud.session }.to raise_error(CurrencyCloud::BadRequestError, expected_error)
  end

  it 'is raised on a bad request' do
    CurrencyCloud.login_id = 'non-existent-login-id'
    CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb57528f0'

    begin
      CurrencyCloud.session
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::BadRequestError => error
      expect(error.code).to eq('auth_invalid_user_login_details')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(400)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('api_key')
      expect(error_message.code).to eq('api_key_length_is_invalid')
      expect(error_message.message).to eq('api_key should be 64 character(s) long')
      expect(error_message.params).to include('length' => 64)
    end
  end

  it 'is raised on incorrect authentication details' do
    CurrencyCloud.login_id = 'non-existent-login-id'
    CurrencyCloud.api_key = 'efb5ae2af84978b7a37f18dd61c8bbe139b403009faea83484405a3dcb64c4d8'

    begin
      CurrencyCloud.session
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::AuthenticationError => error
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
  end

  it 'is raised on unexpected error' do
    allow(HTTParty).to receive(:post).and_raise(Timeout::Error)

    begin
      CurrencyCloud.session
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::UnexpectedError => error
      expected_error = %(CurrencyCloud::UnexpectedError
---
platform: #{platform}
request:
  parameters:
    login_id: REDACTED
    api_key: REDACTED
  verb: post
  url: https://devapi.currencycloud.com/v2/authenticate/api
inner_error: Timeout::Error
)

      expect(error.to_s).to eq(expected_error)
      expect(error.inner_error).to_not be_nil
      expect(error.inner_error.class).to eq(Timeout::Error)
    end
  end

  it 'is raised on a forbidden request' do
    begin
      CurrencyCloud.session
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::ForbiddenError => error
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
  end

  it 'is raised when a resource is not found' do
    CurrencyCloud.token = '656485646b068f6e9c81e3d885fa54f5'
    begin
      CurrencyCloud::Beneficiary.retrieve('081596c9-02de-483e-9f2a-4cf55dcdf98c')
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::NotFoundError => error
      expect(error.code).to eq('beneficiary_not_found')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(404)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('id')
      expect(error_message.code).to eq('beneficiary_not_found')
      expect(error_message.message).to eq('Beneficiary was not found for this id')
      expect(error_message.params).to be_empty
    end
  end

  it 'is raised on an internal server error' do
    begin
      CurrencyCloud.session
      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::InternalApplicationError => error
      expect(error.code).to eq('internal_application_error')
      expect(error.raw_response).to_not be_nil
      expect(error.status_code).to eq(500)
      expect(error.messages.length).to eq(1)

      error_message = error.messages[0]
      expect(error_message.field).to eq('base')
      expect(error_message.code).to eq('internal_application_error')
      expect(error_message.message).to eq('A general application error occurred')
      expect(error_message.params).to include('request_id' => 2771875643610572878)
    end
  end

  it 'is raised when too many requests have been issued' do
    CurrencyCloud.login_id = 'rjnienaber@gmail.com2'

    begin
      CurrencyCloud.session

      expect(0).to eq 1, 'expected exception that was not raised'
    rescue CurrencyCloud::TooManyRequestsError => error
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
