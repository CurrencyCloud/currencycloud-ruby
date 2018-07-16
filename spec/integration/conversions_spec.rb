require 'spec_helper'

describe 'Conversions', vcr: true do
  let(:conversion_params) do
    {
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
        conversion = CurrencyCloud::Conversion.create(conversion_params)
        cancel_without_notes_params = {}
        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion.id, cancel_without_notes_params)

        expect(cancelled_conversion).to have_attributes(
                                          "account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id" => conversion.id,
                                          "event_type" => "self_service_cancellation",
                                          "amount" => "-9.58",
                                          "currency" => "GBP",
                                          "notes" => ""
                                        )
      end
    end

    context 'with notes' do
      it 'has a non-empty "notes" attribute' do
        conversion = CurrencyCloud::Conversion.create(conversion_params)
        cancel_with_notes_params = {
          notes: 'Business Terminated Contract'
        }

        cancelled_conversion = CurrencyCloud::Conversion.cancel(conversion.id, cancel_with_notes_params)

        expect(cancelled_conversion).to have_attributes(
                                          "account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "event_account_id" => "67e1b252-40a7-454d-a097-8f77d385889d",
                                          "event_contact_id" => "04d0c252-7b78-4d72-b408-df78841e3ddc",
                                          "conversion_id" => conversion.id,
                                          "event_type" => "self_service_cancellation",
                                          "amount" => "-9.58",
                                          "currency" => "GBP",
                                          "notes" => "Business Terminated Contract"
                                        )
      end
    end
  end

  it 'can #date_change conversion' do
    new_settlement_date = Time.now + 86400

    conversion = CurrencyCloud::Conversion.create(conversion_params)

    conversion_with_date_changed = CurrencyCloud::Conversion.date_change(conversion.id, new_settlement_date: new_settlement_date)

    expect(conversion_with_date_changed).to have_attributes(
      "conversion_id" => conversion.id,
      "amount" => "-14.38",
      "currency" => "GBP",
      "new_conversion_date" => "2018-07-17T00:00:00+00:00",
      "new_settlement_date" => '2018-07-17T15:30:00+00:00',
      "old_conversion_date" => "2018-07-18T00:00:00+00:00",
      "old_settlement_date" => "2018-07-18T15:30:00+00:00"
    )
  end

  it 'can #split conversion' do
    conversion = CurrencyCloud::Conversion.create(conversion_params)

    split_conversion = CurrencyCloud::Conversion.split(conversion.id, amount: 45_000)

    expect(split_conversion.parent_conversion['sell_amount']).to eq("35513.88")
    expect(split_conversion.parent_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.parent_conversion['buy_amount']).to eq("50000.00")
    expect(split_conversion.parent_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.parent_conversion['settlement_date']).to eq("2018-07-18T15:30:00+00:00")
    expect(split_conversion.parent_conversion['conversion_date']).to eq("2018-07-18T00:00:00+00:00")
    expect(split_conversion.parent_conversion['status']).to eq("awaiting_funds")

    expect(split_conversion.child_conversion['sell_amount']).to eq("31962.50")
    expect(split_conversion.child_conversion['sell_currency']).to eq("GBP")
    expect(split_conversion.child_conversion['buy_amount']).to eq("45000.00")
    expect(split_conversion.child_conversion['buy_currency']).to eq("USD")
    expect(split_conversion.child_conversion['settlement_date']).to eq("2018-07-18T15:30:00+00:00")
    expect(split_conversion.child_conversion['conversion_date']).to eq("2018-07-18T00:00:00+00:00")
    expect(split_conversion.child_conversion['status']).to eq("awaiting_funds")
  end
end
