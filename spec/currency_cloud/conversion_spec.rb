require 'spec_helper'

describe 'Conversions', vcr: true do
  before(:all) do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    CurrencyCloud.token = '935df19150df0e28c5e8ada1944fd342'

    @params = {
      buy_currency: 'USD',
      sell_currency: 'GBP',
      fixed_side: :buy,
      amount: 95_000,
      reason: 'SDK conversion testing',
      term_agreement: true
    }
  end

  describe 'can #cancel conversion' do
    context 'without notes' do
      it 'has a empty "notes" attribute' do
        conversion = CurrencyCloud::Conversion.create(@params)
        cancel_without_notes_params = {}
        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion.id, cancel_without_notes_params)

        expect(cancelled_conversion).to have_attributes(
                                          "account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id" => "e979a3c0-673f-47a7-9ecc-3874643843c5",
                                          "event_type" => "self_service_cancellation",
                                          "amount" => "-9.58",
                                          "currency" => "GBP",
                                          "notes" => "",
                                          "event_date_time" => "2018-05-09T12:38:30+00:00"
                                        )
      end
    end

    context 'with notes' do
      it 'has a non-empty "notes" attribute' do
        conversion = CurrencyCloud::Conversion.create(@params)
        cancel_with_notes_params = {
          :notes => 'Business Terminated Contract'
        }
        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion.id, cancel_with_notes_params)

        expect(cancelled_conversion).to have_attributes(
                                          "account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id" => "86a1bbda-261e-4dd5-8a9f-21ccc420cfb5",
                                          "event_type" => "self_service_cancellation",
                                          "amount" => "-9.58",
                                          "currency" => "GBP",
                                          "notes" => "Business Terminated Contract",
                                          "event_date_time" => "2018-05-09T13:13:12+00:00"
                                        )
      end
    end
  end

  it 'can #date_change conversion' do
    new_settlement_date = "2018-05-14T15:30:00+00:00"
    conversion = CurrencyCloud::Conversion.create(@params)
    date_change_params = {
      :new_settlement_date => new_settlement_date
     }
    conversion_with_date_changed = CurrencyCloud::Conversion.date_change(conversion.id, date_change_params)

    expect(conversion_with_date_changed).to have_attributes(
                                              "conversion_id" => "b34783db-e28c-478d-9967-6faa2431f2ed",
                                              "amount" => "86.13",
                                              "currency" => "GBP",
                                              "new_conversion_date" => "2018-05-14T00:00:00+00:00",
                                              "new_settlement_date" => "2018-05-14T15:30:00+00:00",
                                              "old_conversion_date" => "2018-05-11T00:00:00+00:00",
                                              "old_settlement_date" => "2018-05-11T15:30:00+00:00",
                                              "event_date_time" => "2018-05-09T13:23:26+00:00"
                                            )
  end

  it 'can #split conversion' do
    conversion = CurrencyCloud::Conversion.create(@params)
    split_params = {
      :amount => 45_000
    }
    split_conversion = CurrencyCloud::Conversion.split(conversion.id, split_params)

    expect(split_conversion.parent_conversion['id']).to eq("9f6a6bdc-bec2-4198-b311-e2e74c117c40")
    expect(split_conversion.parent_conversion['short_reference']).to eq("20180509-GWGQGB")
    expect(split_conversion.parent_conversion['sell_amount']).to eq("35513.88")
    expect(split_conversion.parent_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.parent_conversion['buy_amount']).to eq("50000.00")
    expect(split_conversion.parent_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.parent_conversion['settlement_date']).to eq("2018-05-11T15:30:00+00:00")
    expect(split_conversion.parent_conversion['conversion_date']).to eq("2018-05-11T00:00:00+00:00")
    expect(split_conversion.parent_conversion['status']).to eq("awaiting_funds")

    expect(split_conversion.child_conversion['id']).to eq("516265d3-f545-4685-ba8d-e9b70c4e8422")
    expect(split_conversion.child_conversion['short_reference']).to eq("20180509-VYNHGT")
    expect(split_conversion.child_conversion['sell_amount']).to eq("31962.50")
    expect(split_conversion.child_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.child_conversion['buy_amount']).to eq("45000.00")
    expect(split_conversion.child_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.child_conversion['settlement_date']).to eq("2018-05-11T15:30:00+00:00")
    expect(split_conversion.child_conversion['conversion_date']).to eq("2018-05-11T00:00:00+00:00")
    expect(split_conversion.child_conversion['status']).to eq("awaiting_funds")
  end
end
