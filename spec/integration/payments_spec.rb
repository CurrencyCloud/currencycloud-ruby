require 'spec_helper'

describe 'Payments', vcr: true do
  let(:beneficiary_details) do
    {
      bank_account_holder_name: 'Test User',
      bank_country: 'GB',
      currency: 'GBP',
      name: 'Test User',
      account_number: '12345678',
      routing_code_type_1: 'sort_code',
      routing_code_value_1: '123456'
    }
  end

  let(:beneficiary) { CurrencyCloud::Beneficiary.create(beneficiary_details) }

  let(:payment_details) do
    {
      currency: 'GBP',
      beneficiary_id: beneficiary.id,
      amount: '1000',
      reason: 'Testing payments',
      reference: 'Testing payments',
      payment_type: 'regular'
    }
  end

  it 'can #create' do
    payment = CurrencyCloud::Payment.create(payment_details)
    expect(payment).to_not be_nil
    expect(payment).to be_a(CurrencyCloud::Payment)

    expect(payment.reason).to eq 'Testing payments'
  end

  it 'can get the submission' do
    payment = CurrencyCloud::Payment.create(payment_details)
    expect(payment).to_not be_nil

    submission = payment.submission
    expect(submission).to_not be_nil
    expect(submission).to be_a(CurrencyCloud::PaymentSubmission)
  end

  describe "can #authorise" do
    before do
      @payment = CurrencyCloud::Payment.create(payment_details)

      CurrencyCloud.reset_session
      CurrencyCloud.login_id = 'development+authorisations@currencycloud.com'
      CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    end

    it 'when "payment_ids" are valid' do
      authorisations = CurrencyCloud::Payment.authorise(@payment.id)
      expect(authorisations).to_not be_empty

      authorisation = authorisations.first
      expect(authorisation).to be_a CurrencyCloud::PaymentAuthorisationResult

      expect(authorisation.payment_id).to eq @payment.id
      expect(authorisation.payment_status).to eq 'authorised'
      expect(authorisation.updated).to eq true
    end
  end
end
