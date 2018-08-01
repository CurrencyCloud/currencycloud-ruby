require 'spec_helper'

describe 'VirtualAccounts', vcr: true do
  it 'can #find' do
    vans = CurrencyCloud::VirtualAccount.find

    expect(vans).to_not be_empty
    expect(vans).to be_a(CurrencyCloud::VirtualAccounts)

    van = vans[0]
    expect(van).to be_a(CurrencyCloud::VirtualAccount)
    expect(van.id).to eq "00d272ee-fae5-4f97-b425-993a2d6e3a46"
    expect(van.virtual_account_number).to eq '8303723297'
  end

  it 'can find VANs for subaccounts' do
    vans = CurrencyCloud::VirtualAccount.for_subaccounts
    expect(vans).to_not be_empty
    expect(vans).to be_a(CurrencyCloud::VirtualAccounts)

    van = vans[0]
    expect(van).to be_a(CurrencyCloud::VirtualAccount)
    expect(van.id).to eq "00d272ee-fae5-4f97-b425-993a2d6e3a46"
    expect(van.virtual_account_number).to eq '8303723297'
  end

  it 'can find VANs for a specific subaccount' do
    vans = CurrencyCloud::VirtualAccount.for_subaccount('87077161-91de-012f-e284-1e0030c7f353')
    expect(vans).to_not be_empty
    expect(vans).to be_a(CurrencyCloud::VirtualAccounts)

    van = vans[0]
    expect(van).to be_a(CurrencyCloud::VirtualAccount)
    expect(van.id).to eq "00d272ee-fae5-4f97-b425-993a2d6e3a46"
    expect(van.virtual_account_number).to eq '8303723297'
  end
end
