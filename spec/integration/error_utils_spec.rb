require 'spec_helper'

describe 'ErrorUtils' do
  module CurrencyCloud
    class ErrorUtilTester
      extend ErrorUtils
    end
  end

  it 'can #redact_params' do
    params = {
      unaffected: 'value',
      api_key: 'value',
      login_id: 'value',
      token: 'value'
    }

    redacted = CurrencyCloud::ErrorUtilTester.redacted_params(params)

    expect(redacted[:unaffected]).to eq 'value'
    expect(redacted[:api_key]).to eq CurrencyCloud::ErrorUtils::REDACTED_STRING
    expect(redacted[:login_id]).to eq CurrencyCloud::ErrorUtils::REDACTED_STRING
    expect(redacted[:token]).to eq CurrencyCloud::ErrorUtils::REDACTED_STRING

    expect(params[:unaffected]).to eq 'value'
    expect(params[:api_key]).to eq 'value'
    expect(params[:login_id]).to eq 'value'
    expect(params[:token]).to eq 'value'
  end
end
