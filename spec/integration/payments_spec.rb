# frozen_string_literal: true

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

  it "can retrieve #confirmation" do
    payment = CurrencyCloud::Payment.retrieve('fda8cf13-ccf6-4423-8b0f-1443e3459ce0')
    payment_confirmation_result = payment.confirmation

    expect(payment_confirmation_result.id).to eq('5d9c99a7-1522-48b1-9221-69e929eb3807')
    expect(payment_confirmation_result.payment_id).to eq('fda8cf13-ccf6-4423-8b0f-1443e3459ce0')
    expect(payment_confirmation_result.account_id).to eq('bf5b1007-b364-43cc-b3d6-9f2d1be75297')
    expect(payment_confirmation_result.short_reference).to eq('PC-9727672-HCPLFC')
    expect(payment_confirmation_result.status).to eq('completed')
    expect(payment_confirmation_result.confirmation_url).to eq('https://ccycloud-payment-confirmations-prod-demo1.s3.eu-west-1.amazonaws.com/payment_confirmations/5d9c99a7-1522-48b1-9221-69e929eb3807/181107-VTCWNQ001.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=cred123abc&X-Amz-Date=20181130T080707Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Security-Token=token123abc&X-Amz-Signature=signature123abc')
    expect(payment_confirmation_result.created_at).to eq('2018-11-30T07:57:24+00:00')
    expect(payment_confirmation_result.updated_at).to eq('2018-11-30T07:57:24+00:00')
    expect(payment_confirmation_result.expires_at).to eq('2018-12-02T00:00:00+00:00')
  end
end
