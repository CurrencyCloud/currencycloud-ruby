require 'spec_helper'

describe 'Actions', vcr: true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = '4df5b3e5882a412f148dcd08fa4e5b73'
  end

  it 'can #create' do
    params = {
      bank_account_holder_name: 'Test User',
      bank_country: 'GB',
      currency: 'GBP',
      name: 'Test User',
      account_number: '12345678',
      routing_code_type_1: 'sort_code',
      routing_code_value_1: '123456',
      payment_types: ['regular']
    }

    beneficiary = CurrencyCloud::Beneficiary.create(params)
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T09:21:00+00:00')
  end

  it 'can #retrieve' do
    beneficiary = CurrencyCloud::Beneficiary.retrieve('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T09:21:00+00:00')
  end

  it 'can #first' do
    beneficiary = CurrencyCloud::Beneficiary.first(bank_account_holder_name: 'Test User')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T10:58:21+00:00')
  end

  it 'can #find' do
    beneficiaries = CurrencyCloud::Beneficiary.find
    expect(beneficiaries).to_not be_empty
    expect(beneficiaries.length).to eq(1)

    beneficiaries.each do |b|
      expect(b).to_not be_nil
      expect(b).to be_a_kind_of(CurrencyCloud::Beneficiary)
    end

    pagination = beneficiaries.pagination
    expect(pagination.total_entries).to eq(1)
    expect(pagination.total_pages).to eq(1)
    expect(pagination.current_page).to eq(1)
    expect(pagination.per_page).to eq(25)
    expect(pagination.previous_page).to eq(-1)
    expect(pagination.next_page).to eq(-1)
    expect(pagination.order).to eq('created_at')
    expect(pagination.order_asc_desc).to eq('asc')
  end

  it 'can #update' do
    beneficiary = CurrencyCloud::Beneficiary.update('081596c9-02de-483e-9f2a-4cf55dcdf98c', bank_account_holder_name: 'Test User 2')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)
    expect(beneficiary.bank_account_holder_name).to eq('Test User 2')
  end

  it 'can #delete' do
    beneficiary = CurrencyCloud::Beneficiary.delete('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User 2')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T11:06:27+00:00')
  end

  it 'can #current' do
    account = CurrencyCloud::Account.current

    expect(account).to be_a_kind_of(CurrencyCloud::Account)
    expect(account.id).to eq('8ec3a69b-02d1-4f09-9a6b-6bd54a61b3a8')
    expect(account.postal_code).to be_nil
    expect(account.created_at).to eq('2015-04-24T15:57:55+00:00')
    expect(account.updated_at).to eq('2015-04-24T15:57:55+00:00')
  end

  it 'can #validate beneficiaries' do
    params = {
      bank_country: 'GB',
      currency: 'GBP',
      account_number: '12345678',
      routing_code_type_1: 'sort_code',
      routing_code_value_1: '123456',
      payment_types: ['regular']
    }

    beneficiary = CurrencyCloud::Beneficiary.validate(params)
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.account_number).to include('12345678')
    expect(beneficiary.payment_types).to include('regular')
  end

  it 'can use #currency to retrieve balance' do
    balance = CurrencyCloud::Balance.currency('GBP')

    expect(balance).to be_a_kind_of(CurrencyCloud::Balance)

    expect(balance.id).to eq('5a998e06-3eb7-46d6-ba58-f749864159ce')
    expect(balance.amount).to eq('999866.78')
    expect(balance.created_at).to eq('2014-12-04T09:50:35+00:00')
    expect(balance.updated_at).to eq('2015-03-23T14:33:37+00:00')
  end

  it 'can top up margin balance' do
    top_up = CurrencyCloud::Balance.top_up_margin(currency: 'GBP', amount: 450)

    expect(top_up).to be_a_kind_of(CurrencyCloud::MarginBalanceTopUp)

    expect(top_up.accpunt_id).to eq('6c046c51-2387-4004-8e87-4bf97102e36')
    expect(top_up.amount).to eq('450.0')
    expect(top_up.currency).to eq('GBP')
    expect(top_up.transfer_completed_at).to eq('2007-11-19 14:37:48')
  end
end
