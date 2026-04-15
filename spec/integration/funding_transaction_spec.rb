require 'spec_helper'

describe 'FundingTransactions', vcr: true do
  before do
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it 'can #retrieve' do
    funding_transaction = CurrencyCloud::FundingTransaction.retrieve('a1b2c3d4-e5f6-7890-abcd-ef1234567890')

    expect(funding_transaction).to be_a(CurrencyCloud::FundingTransaction)
    expect(funding_transaction.id).to eq('a1b2c3d4-e5f6-7890-abcd-ef1234567890')
    expect(funding_transaction.amount).to eq('1000.00')
    expect(funding_transaction.currency).to eq('USD')
    expect(funding_transaction.rail).to eq('swift')
    expect(funding_transaction.additional_information).to eq('ABCD20231016143117')
    expect(funding_transaction.receiving_account_routing_code).to eq('026009593')
    expect(funding_transaction.value_date).to eq('2022-12-03T00:00:00+00:00')
    expect(funding_transaction.receiving_account_number).to eq('1234567890')
    expect(funding_transaction.receiving_account_iban).to eq('GB82WEST12345698765432')
    expect(funding_transaction.created_at).to eq('2022-12-03T10:15:30+00:00')
    expect(funding_transaction.updated_at).to eq('2022-12-03T10:15:31+00:00')
    expect(funding_transaction.completed_at).to eq('2022-12-03T10:15:30+00:00')
  end
end
