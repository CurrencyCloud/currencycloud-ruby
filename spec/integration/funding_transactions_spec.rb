# frozen_string_literal: true

require 'spec_helper'

describe 'FundingTransactions', vcr: true do
  it 'can retrieve funding transaction' do
    funding_transaction = CurrencyCloud::FundingTransactions.retrieve_funding_transaction('e68301d3-5b04-4c1d-8f8b-13a9b8437040')

    expect(funding_transaction.id).to eq('e68301d3-5b04-4c1d-8f8b-13a9b8437040')
    expect(funding_transaction.currency).to eq('USD')
    expect(funding_transaction.sender['sender_country']).to eq('GB')
  end
end
