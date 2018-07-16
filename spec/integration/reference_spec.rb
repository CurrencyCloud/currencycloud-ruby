require 'spec_helper'

describe 'Reference', vcr: true do
  before do
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it 'can retrieve #beneficiary_required_details' do
    details = CurrencyCloud::Reference.beneficiary_required_details(currency: 'GBP', bank_account_country: 'GB', beneficiary_country: 'GB')
    expect(details).to_not be_empty

    details = details.first
    expect(details['payment_type']).to eq('regular')
    expect(details['beneficiary_entity_type']).to eq('individual')
    expect(details['acct_number']).to eq('^[0-9A-Z]{1,50}$')
    expect(details['sort_code']).to eq('^\\d{6}$')
  end

  it 'can retrieve #conversion_dates' do
    dates = CurrencyCloud::Reference.conversion_dates(conversion_pair: 'GBPUSD')

    expect(dates.invalid_conversion_dates).to_not be_empty
    invalid_conversion_date = dates.invalid_conversion_dates.first
    expect(invalid_conversion_date).to eq(['2018-07-21', 'No trading on Saturday'])
    expect(dates.first_conversion_date).to eq('2018-07-16')
    expect(dates.default_conversion_date).to eq('2018-07-18')
  end

  it 'can retrieve #currencies' do
    currencies = CurrencyCloud::Reference.currencies
    expect(currencies).to_not be_empty

    currency = currencies.first
    expect(currency).to be_a(CurrencyCloud::Currency)
    expect(currency.code).to eq('AED')
    expect(currency.name).to eq('United Arab Emirates Dirham')
    expect(currency.decimal_places).to eq(2)
  end

  it 'can retrieve #payer_required_details' do
    payer_required_details = CurrencyCloud::Reference.payer_required_details(payer_country: 'GB')
    expect(payer_required_details).to_not be_empty

    required_details = payer_required_details[0]
    expect(required_details).to be_a(CurrencyCloud::PayerRequiredDetails)

    expect(required_details.payer_entity_type).to_not be_nil
    expect(required_details.payment_type).to_not be_nil
    expect(required_details.required_fields).to_not be_empty
  end

  it 'can retrieve #payment_dates' do
    payment_dates = CurrencyCloud::Reference.payment_dates(currency: 'GBP')
    expect(payment_dates).to_not be_nil
    expect(payment_dates).to be_a(CurrencyCloud::PaymentDates)

    expect(payment_dates.invalid_payment_dates).to_not be_empty
  end

  it 'can retrieve #payment_purpose_codes' do
    payment_purpose_codes = CurrencyCloud::Reference.payment_purpose_codes(currency: 'INR')
    expect(payment_purpose_codes).to_not be_empty

    purpose_code = payment_purpose_codes.first
    expect(purpose_code).to be_a(CurrencyCloud::PurposeCode)
  end

  it 'can retrieve #settlement_accounts' do
    settlement_accounts = CurrencyCloud::Reference.settlement_accounts(currency: 'GBP')
    expect(settlement_accounts).to_not be_empty

    settlement_account = settlement_accounts.first
    expect(settlement_account).to be_a(CurrencyCloud::SettlementAccount)
    expect(settlement_account.bank_account_holder_name).to eq('The Currency Cloud GBP - Client Seg A/C')
    expect(settlement_account.bank_address).to be_empty
  end
end
