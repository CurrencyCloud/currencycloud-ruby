require 'spec_helper'

describe 'Reference', :vcr => true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = '1c9da5726314246acfb09ec5651307a5'
  end

  it 'can retrieve #beneficiary_required_details' do
    details = CurrencyCloud::Reference.beneficiary_required_details(:currency => 'GBP', :bank_account_country => 'GB', :beneficiary_country => 'GB')
    expect(details).to_not be_empty

    details = details.first
    expect(details['payment_type']).to eq('priority')
    expect(details["payment_type"]).to eq("priority")
    expect(details["beneficiary_entity_type"]).to eq("individual")
    expect(details["beneficiary_address"]).to eq("^.{1,255}")
    expect(details["beneficiary_city"]).to eq("^.{1,255}")
    expect(details["beneficiary_country"]).to eq("^[A-z]{2}$")
    expect(details["beneficiary_first_name"]).to eq("^.{1,255}")
    expect(details["beneficiary_last_name"]).to eq("^.{1,255}")
    expect(details["acct_number"]).to eq("^[0-9A-Z]{1,50}$")
    expect(details["sort_code"]).to eq("^\\d{6}$")
  end

  it 'can retrieve #conversion_dates' do
    dates = CurrencyCloud::Reference.conversion_dates(:conversion_pair => 'GBPUSD')

    expect(dates.invalid_conversion_dates).to_not be_empty
    invalid_conversion_date = dates.invalid_conversion_dates.first
    expect(invalid_conversion_date).to eq(["2015-05-02", "No trading on Saturday"])
    expect(dates.first_conversion_date).to eq('2015-04-30')
    expect(dates.default_conversion_date).to eq('2015-04-30')
  end

  it 'can retrieve #currencies' do
    currencies = CurrencyCloud::Reference.currencies
    expect(currencies).to_not be_empty

    currency = currencies.first
    expect(currency).to be_a_kind_of(CurrencyCloud::Currency)
    expect(currency.code).to eq('AED')
    expect(currency.name).to eq('United Arab Emirates Dirham')
    expect(currency.decimal_places).to eq(2)
  end

  it 'can retrieve #settlement_accounts' do
    settlement_accounts = CurrencyCloud::Reference.settlement_accounts(:currency => 'GBP')
    expect(settlement_accounts).to_not be_empty

    settlement_account = settlement_accounts.first
    expect(settlement_account).to be_a_kind_of(CurrencyCloud::SettlementAccount)
    expect(settlement_account.bank_account_holder_name).to eq("The Currency Cloud GBP - Client Seg A/C")
    expect(settlement_account.bank_address).to be_empty
  end
end
