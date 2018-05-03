require 'spec_helper'

describe 'Conversions', vcr: true do
  before(:all) do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'mark.sutton@currencycloud.com'
    CurrencyCloud.api_key = '48a3d8694aeb1132588a27d1a7dbbc4ef92dbebd83e51194a67a02f9b81f67d8'

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
        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion_id: conversion.id)
        expect(cancelled_conversion).to have_attributes(
                                          "account_id":"67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id":"04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id":"67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id":"04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id":"44f84041-dad3-45a7-a1e6-22d05c4343ce",
                                          "event_type":"self_service_cancellation",
                                          "amount":"-9.56",
                                          "currency":"GBP",
                                          "notes":"",
                                          "event_date_time":"2018-05-03T13:39:39+00:00"
                                        )
      end
    end

    context 'with notes' do
      it 'has a non-empty "notes" attribute' do
        conversion = CurrencyCloud::Conversion.create(@params)
        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion_id: conversion.id, notes: 'Business Terminated Contract')
        expect(cancelled_conversion).to have_attributes(
                                          "account_id":"67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id":"04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id":"67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id":"04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id":"e65386d5-1f67-4b59-85cd-3a6da3aa2a25",
                                          "event_type":"self_service_cancellation",
                                          "amount":"-9.56",
                                          "currency":"GBP",
                                          "notes":"Business Terminated Contract",
                                          "event_date_time" => "2018-05-03T13:39:41+00:00"
                                        )
      end
    end
  end

  it 'can #date_change conversion' do
    new_settlement_date = "2018-05-09T10:00:00+00:00"
    conversion = CurrencyCloud::Conversion.create(@params)
    conversion_with_date_changed = CurrencyCloud::Conversion.date_change(conversion_id: conversion.id, new_settlement_date: new_settlement_date)
    expect(conversion_with_date_changed).to have_attributes(
                                              "conversion_id":"bd8e2f9f-de20-4e81-910a-b6e9730762bd",
                                              "amount":"-9.56",
                                              "currency":"GBP",
                                              "new_conversion_date":"2018-05-09T00:00:00+00:00",
                                              "new_settlement_date":"2018-05-09T15:30:00+00:00",
                                              "old_conversion_date":"2018-05-08T00:00:00+00:00",
                                              "old_settlement_date":"2018-05-08T15:30:00+00:00",
                                              "event_date_time":"2018-05-03T14:07:08+00:00"
                                            )
  end

  it 'can #split conversion' do
    conversion = CurrencyCloud::Conversion.create(@params)
    split_conversion = CurrencyCloud::Conversion.split(conversion_id: conversion.id, amount: 45_000)
    expect(split_conversion.parent_conversion['id']).to eq("6680fe77-24f9-482f-8174-293169f85675")
    expect(split_conversion.parent_conversion['short_reference']).to eq("20180503-KCHPPG")
    expect(split_conversion.parent_conversion['sell_amount']).to eq("35463.51")
    expect(split_conversion.parent_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.parent_conversion['buy_amount']).to eq("50000.00")
    expect(split_conversion.parent_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.parent_conversion['settlement_date']).to eq("2018-05-08T15:30:00+00:00")
    expect(split_conversion.parent_conversion['conversion_date']).to eq("2018-05-08T00:00:00+00:00")
    expect(split_conversion.parent_conversion['status']).to eq("awaiting_funds")

    expect(split_conversion.child_conversion['id']).to eq("2ccefd27-f1f5-430a-ac91-3956e47fc814")
    expect(split_conversion.child_conversion['short_reference']).to eq("20180503-LXPLPB")
    expect(split_conversion.child_conversion['sell_amount']).to eq("31917.16")
    expect(split_conversion.child_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.child_conversion['buy_amount']).to eq("45000.00")
    expect(split_conversion.child_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.child_conversion['settlement_date']).to eq("2018-05-08T15:30:00+00:00")
    expect(split_conversion.child_conversion['conversion_date']).to eq("2018-05-08T00:00:00+00:00")
    expect(split_conversion.child_conversion['status']).to eq("awaiting_funds")
  end
end