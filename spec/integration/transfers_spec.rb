require 'spec_helper'

describe 'Transfers', vcr: true do
  let(:transfer_details) do
    {
      source_account_id: 'd0ad035e-b699-4fcd-a73c-13fb0910a884',
      destination_account_id: 'e54a5e86-80ad-4434-90fe-0c8c751666de',
      currency: 'GBP',
      amount: '1000'
    }
  end

  it 'can #create' do
    transfer = CurrencyCloud::Transfer.create(transfer_details)
    expect(transfer).to_not be_nil
    expect(transfer).to be_a(CurrencyCloud::Transfer)

    expect(transfer.source_account_id).to eq 'd0ad035e-b699-4fcd-a73c-13fb0910a884'
  end

  it 'can #find' do
    CurrencyCloud::Transfer.create(transfer_details)

    transfers = CurrencyCloud::Transfer.find(currency: 'GBP', per_page: 1)
    expect(transfers.length).to eq 1

    transfer = transfers[0]
    expect(transfer).to be_a(CurrencyCloud::Transfer)
    expect(transfer.currency).to eq 'GBP'
  end

  it 'can #retrieve' do
    transfer_id = CurrencyCloud::Transfer.create(transfer_details).id

    transfer = CurrencyCloud::Transfer.retrieve(transfer_id)
    expect(transfer).to_not be_nil
    expect(transfer).to be_a(CurrencyCloud::Transfer)
  end

    it 'can #cancel' do
      transfer_id = CurrencyCloud::Transfer.create(transfer_details).id

      transfer = CurrencyCloud::Transfer.cancel(transfer_id)
      expect(transfer).to_not be_nil
      expect(transfer).to be_a(CurrencyCloud::Transfer)
      expect(transfer.status).to eq 'cancelled'
    end
end
