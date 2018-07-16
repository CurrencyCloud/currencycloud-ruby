require 'spec_helper'

describe 'Payment', vcr: true do
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
end
