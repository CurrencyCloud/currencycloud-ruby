require 'spec_helper'

describe 'Reporting', vcr: true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = '1c9da5726314246acfb09ec5651307a5'
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'

  end

  it 'generates a report for a conversion' do
    expect(CurrencyCloud::Report.create_conversion_report).to be_a_kind_of(CurrencyCloud::Report)
    expect(CurrencyCloud::Report.create_conversion_report).to eq('A')
  end

  xit 'generates a report for a payment' do
    expect(CurrencyCloud::Report.create_payment_report).to be_a_kind_of(CurrencyCloud::Report)
    expect(CurrencyCloud::Report.create_payment_report).to eq('A')
  end

  xit 'retrieve a single report request' do

  end

  xit 'retrieves all reports' do

  end
end
