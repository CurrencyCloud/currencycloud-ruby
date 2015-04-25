require 'spec_helper'

describe 'Actions', :vcr => true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = 'e5070d4a16c5ffe4ed9fb268a2a716be'
  end

  it "can #create" do
    params = {
      :bank_account_holder_name => 'Test User',
      :bank_country => 'GB',
      :currency => 'GBP',
      :name => 'Test User',
      :account_number => '12345678',
      :routing_code_type_1 => 'sort_code',
      :routing_code_value_1 => '123456',
      :payment_types => ['regular']
    }

    beneficiary = CurrencyCloud::Beneficiary.create(params)
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T09:21:00+00:00')
  end

  it "can #retrieve" do
    beneficiary = CurrencyCloud::Beneficiary.retrieve('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T09:21:00+00:00')
  end

  it "can #first" do
    beneficiary = CurrencyCloud::Beneficiary.first(:bank_account_holder_name => 'Test User')
    expect(beneficiary).to be_a_kind_of(CurrencyCloud::Beneficiary)

    expect(beneficiary.id).to eq('081596c9-02de-483e-9f2a-4cf55dcdf98c')
    expect(beneficiary.bank_account_holder_name).to eq('Test User')
    expect(beneficiary.payment_types).to include('regular')
    expect(beneficiary.created_at).to eq('2015-04-25T09:21:00+00:00')
    expect(beneficiary.updated_at).to eq('2015-04-25T09:21:00+00:00')
  end

  it "can #find" do
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
end