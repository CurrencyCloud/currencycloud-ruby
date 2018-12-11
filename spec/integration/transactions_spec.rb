# frozen_string_literal: true
require 'spec_helper'

describe 'Transactions', vcr: true do
  it 'can #retrieve_sender_details' do
    sender_details = CurrencyCloud::Transaction.retrieve_sender_details('e68301d3-5b04-4c1d-8f8b-13a9b8437040')

    expect(sender_details.id).to eq('e68301d3-5b04-4c1d-8f8b-13a9b8437040')
    expect(sender_details.amount).to eq('1701.51')
    expect(sender_details.currency).to eq('EUR')
    expect(sender_details.additional_information).to eq('USTRD-0001')
    expect(sender_details.value_date).to eq('2018-07-04T00:00:00+00:00')
    expect(sender_details.sender).to eq('FR7615589290001234567890113, CMBRFR2BARK, Debtor, FR, Centre ville')
    expect(sender_details.receiving_account_number).to eq(nil)
    expect(sender_details.receiving_account_iban).to eq('GB99OXPH94665099600083')
    expect(sender_details.created_at).to eq('2018-07-04T14:57:38+00:00')
    expect(sender_details.updated_at).to eq('2018-07-04T14:57:39+00:00')
  end
end
