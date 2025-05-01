require 'spec_helper'

describe 'IBANs', vcr: true do
  it 'can #find' do
    ibans = CurrencyCloud::IBAN.find

    expect(ibans).to_not be_empty
    expect(ibans).to be_a(CurrencyCloud::IBANs)

    iban = ibans[0]
    expect(iban).to be_a(CurrencyCloud::IBAN)
    expect(iban.id).to eq "8242d1f4-4555-4155-a9bf-30feee785121"
    expect(iban.iban_code).to eq 'GB33BUKB20201555555555'
    expect(iban.currency).to eq 'EUR'
  end

  it 'can IBANs for subaccounts' do
    ibans = CurrencyCloud::IBAN.for_subaccounts

    expect(ibans).to_not be_empty
    expect(ibans).to be_a(CurrencyCloud::IBANs)

    iban = ibans[0]
    expect(iban).to be_a(CurrencyCloud::IBAN)
    expect(iban.id).to eq "01d8c0bc-7f0c-4cdd-bc7e-ef81f68500fe"
    expect(iban.iban_code).to eq 'FR7630006000011234567890189'
    expect(iban.currency).to eq 'EUR'
  end

  it 'can IBANs for a specific subaccount' do
    ibans = CurrencyCloud::IBAN.for_subaccount('87077161-91de-012f-e284-1e0030c7f353')

    expect(ibans).to_not be_empty
    expect(ibans).to be_a(CurrencyCloud::IBANs)

    iban = ibans[0]
    expect(iban).to be_a(CurrencyCloud::IBAN)
    expect(iban.id).to eq "01d8c0bc-7f0c-4cdd-bc7e-ef81f68500fe"
    expect(iban.iban_code).to eq 'GB51TCCL00997997989490'
    expect(iban.currency).to eq 'JPY'
  end
end
