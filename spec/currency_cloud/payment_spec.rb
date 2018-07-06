require 'spec_helper'

describe 'Payment', vcr: true do
  before(:each) do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
  end

  let(:beneficiary_params) do
    {
      name: 'Employee Funds',
      bank_account_holder_name: 'John Doe',
      bank_country: 'GB',
      currency: 'GBP',
      email: 'john.doe@acme.com',
      account_number: '1204567890003466',
      routing_code_type_1: 'sort_code',
      routing_code_value_1: '990901'
    }
  end

  let(:beneficiary) do
    CurrencyCloud::Beneficiary.create(beneficiary_params)
  end

  let(:payment_params) do
    {
      currency: 'GBP',
      beneficiary_id: beneficiary.id,
      amount: 1_500,
      reason: 'SDK payment testing',
      reference: 'My reference code',
      payment_type: 'regular'
    }
  end

  describe "can #authorise" do
    before do
      @params = {
        payment_ids: [CurrencyCloud::Payment.create(payment_params).id]
      }

      CurrencyCloud.reset_session
      CurrencyCloud.login_id = 'development+authorisations@currencycloud.com'
      CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    end

    it 'when "payment_ids" are valid' do
      payment_for_authorisation = CurrencyCloud::Payment.authorise(@params)
      result = payment_for_authorisation.authorisations.first

      expect(result).to include(
        "payment_id" => @params[:payment_ids].first,
        "payment_status" => "authorised",
        "updated" => true,
        "error" => nil,
        "auth_steps_taken" => result["auth_steps_taken"],
        "auth_steps_required" => result["auth_steps_required"],
        "short_reference" => result["short_reference"]
      )
    end
  end
end
