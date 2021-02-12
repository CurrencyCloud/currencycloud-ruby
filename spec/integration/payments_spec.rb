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


  it "can retrieve #payment_delivery_date" do
    result = CurrencyCloud::Payment.payment_delivery_date(payment_date: '2019-06-07', payment_type: 'regular', currency: 'GBP', bank_country: 'GB')

    expect(result).to_not be_nil
    expect(result.payment_date).to eq('2019-06-07')
    expect(result.payment_delivery_date).to eq('2019-06-07T00:00:00+00:00')
    expect(result.payment_cutoff_time).to eq('2019-06-07T14:30:00+00:00')
    expect(result.payment_type).to eq('regular')
    expect(result.currency).to eq('GBP')
    expect(result.bank_country).to eq('GB')
  end

  it "can retrieve #quote_payment_fee" do
    quote_payment_fee = CurrencyCloud::Payment.quote_payment_fee(payment_date: "2019-06-07", payment_type: "regular", currency: "GBP", bank_country: "GB")

    expect(quote_payment_fee).to_not be_nil
    expect(quote_payment_fee.account_id).to eq("0534aaf2-2egg-0134-2f36-10b11cd33cfb")
    expect(quote_payment_fee.fee_amount).to eq("10.00")
    expect(quote_payment_fee.fee_currency).to eq("EUR")
    expect(quote_payment_fee.payment_currency).to eq("USD")
    expect(quote_payment_fee.payment_destination_country).to eq("US")
    expect(quote_payment_fee.payment_type).to eq("regular")
    expect(quote_payment_fee.charge_type).to be_nil
  end

  it "can retrieve #payment_tracking_info" do
    payment_tracking_info = CurrencyCloud::Payment.tracking_info("46ed4827-7b6f-4491-a06f-b548d5a7512d")

    expect(payment_tracking_info).to be_a(CurrencyCloud::PaymentTrackingInfo)
    expect(payment_tracking_info.uetr).to eq("46ed4827-7b6f-4491-a06f-b548d5a7512d")
    expect(payment_tracking_info.transaction_status["status"]).to eq("processing")
    expect(payment_tracking_info.transaction_status["reason"]).to eq("transferred_and_tracked")
    expect(payment_tracking_info.initiation_time).to eq("2019-07-09T13:20:30+00:00")
    expect(payment_tracking_info.completion_time).to be_nil
    expect(payment_tracking_info.last_update_time).to eq("2019-07-10T15:39:08+00:00")
    expect(payment_tracking_info.payment_events.length).to eq(7)
    expect(payment_tracking_info.payment_events[6]["tracker_event_type"]).to eq("customer_credit_transfer_payment")
    expect(payment_tracking_info.payment_events[6]["instructed_amount"]["amount"]).to eq("745437.57")
  end

  it 'can create #bad_request' do
    begin
      payment = CurrencyCloud::Payment.create()
    rescue CurrencyCloud::BadRequestError => error
      #All Good. Expected
      expect(error.messages.length).to eq 10
      expect(error.messages[0].field).to eq "currency"
      expect(error.messages[0].code).to eq "currency_is_required"
      expect(error.messages[2].field).to eq "beneficiary_id"
      expect(error.messages[2].code).to eq "beneficiary_id_is_required"
    end
  end

end
