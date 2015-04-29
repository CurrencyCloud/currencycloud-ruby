require 'spec_helper'

describe 'Reference', :vcr => true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = '242993ca94b9d1c6c1d8f7d3275a6f36'
  end

  pending 'can #beneficiary_required_details' do
    details = CurrencyCloud::Rate.beneficiary_required_details(:currency => 'GBP', :bank_account_country => 'GB', :beneficiary_country => 'GB')
  end 

  pending 'can #conversion_dates' do
    dates = CurrencyCloud::Rate.conversion_dates(:conversion_pair => 'GBPUSD')
  end 

  pending 'can #currencies' do
    currencies = CurrencyCloud::Rate.currencies
  end 

  pending 'can #settlement_accounts' do
    dates = CurrencyCloud::Rate.settlement_accounts(:currency => 'GBP')
  end 
end