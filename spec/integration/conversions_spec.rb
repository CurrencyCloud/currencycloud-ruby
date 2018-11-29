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
        cancelled_conversion = conversion.cancel

        expect(cancelled_conversion).to have_attributes(
          'account_id' => '67e1b252-40a7-454d-a097-8f77d385889d',
          'contact_id' => '04d0c252-7b78-4d72-b408-df78841e3ddc',
          'event_account_id' => '67e1b252-40a7-454d-a097-8f77d385889d',
          'event_contact_id' => '04d0c252-7b78-4d72-b408-df78841e3ddc',
          'conversion_id' => conversion.id,
          'event_type' => 'self_service_cancellation',
          'amount' => '-9.58',
          'currency' => 'GBP',
          'notes' => ''
        )
      end
    end

    context 'with notes' do
      it 'has a non-empty "notes" attribute' do
        conversion = CurrencyCloud::Conversion.create(conversion_params)
        cancelled_conversion = conversion.cancel(notes: 'Business Terminated Contract')

        expect(cancelled_conversion).to have_attributes(
          'account_id' => '67e1b252-40a7-454d-a097-8f77d385889d',
          'contact_id' => '04d0c252-7b78-4d72-b408-df78841e3ddc',
          'event_account_id' => '67e1b252-40a7-454d-a097-8f77d385889d',
          'event_contact_id' => '04d0c252-7b78-4d72-b408-df78841e3ddc',
          'conversion_id' => conversion.id,
          'event_type' => 'self_service_cancellation',
          'amount' => '-9.58',
          'currency' => 'GBP',
          'notes' => 'Business Terminated Contract'
        )
      end
    end
  end

  it 'can #date_change conversion' do
    new_settlement_date = Time.now + 86400

    conversion = CurrencyCloud::Conversion.create(conversion_params)

    conversion_with_date_changed = conversion.date_change(new_settlement_date: new_settlement_date)

    expect(conversion_with_date_changed).to have_attributes(
      'conversion_id' => conversion.id,
      'amount' => '-14.38',
      'currency' => 'GBP',
      'new_conversion_date' => '2018-07-17T00:00:00+00:00',
      'new_settlement_date' => '2018-07-17T15:30:00+00:00',
      'old_conversion_date' => '2018-07-18T00:00:00+00:00',
      'old_settlement_date' => '2018-07-18T15:30:00+00:00'
    )
  end

  it 'can #split conversion' do
    conversion = CurrencyCloud::Conversion.create(conversion_params)

    split_conversion = conversion.split(amount: 45_000)

    expect(split_conversion.parent_conversion['sell_amount']).to eq('35513.88')
    expect(split_conversion.parent_conversion['sell_currency']).to eq('GBP')
    expect(split_conversion.parent_conversion['buy_amount']).to eq('50000.00')
    expect(split_conversion.parent_conversion['buy_currency']).to eq('USD')
    expect(split_conversion.parent_conversion['settlement_date']).to eq('2018-07-18T15:30:00+00:00')
    expect(split_conversion.parent_conversion['conversion_date']).to eq('2018-07-18T00:00:00+00:00')
    expect(split_conversion.parent_conversion['status']).to eq('awaiting_funds')

    expect(split_conversion.child_conversion['sell_amount']).to eq('31962.50')
    expect(split_conversion.child_conversion['sell_currency']).to eq('GBP')
    expect(split_conversion.child_conversion['buy_amount']).to eq('45000.00')
    expect(split_conversion.child_conversion['buy_currency']).to eq('USD')
    expect(split_conversion.child_conversion['settlement_date']).to eq('2018-07-18T15:30:00+00:00')
    expect(split_conversion.child_conversion['conversion_date']).to eq('2018-07-18T00:00:00+00:00')
    expect(split_conversion.child_conversion['status']).to eq('awaiting_funds')
  end

  it 'can #retrieve_profit_and_loss' do
    profit_and_loss = CurrencyCloud::Conversion.retrieve_profit_and_loss()

    expect(profit_and_loss.conversion_profit_and_losses[0]['account_id']).to eq('72970a7c-7921-431c-b95f-3438724ba16f')
    expect(profit_and_loss.conversion_profit_and_losses[0]['contact_id']).to eq('a66ca63f-e668-47af-8bb9-74363240d781')
    expect(profit_and_loss.conversion_profit_and_losses[0]['event_account_id']).to eq(nil)
    expect(profit_and_loss.conversion_profit_and_losses[0]['event_contact_id']).to eq(nil)
    expect(profit_and_loss.conversion_profit_and_losses[0]['conversion_id']).to eq('515eaa18-0756-42b9-9899-49bfea5d3e8a')
    expect(profit_and_loss.conversion_profit_and_losses[0]['event_type']).to eq('self_service_cancellation')
    expect(profit_and_loss.conversion_profit_and_losses[0]['amount']).to eq('-0.01')
    expect(profit_and_loss.conversion_profit_and_losses[0]['currency']).to eq('GBP')

    expect(profit_and_loss.conversion_profit_and_losses[1]['account_id']).to eq('72970a7c-7921-431c-b95f-3438724ba16f')
    expect(profit_and_loss.conversion_profit_and_losses[1]['contact_id']).to eq('a66ca63f-e668-47af-8bb9-74363240d781')
    expect(profit_and_loss.conversion_profit_and_losses[1]['event_account_id']).to eq(nil)
    expect(profit_and_loss.conversion_profit_and_losses[1]['event_contact_id']).to eq(nil)
    expect(profit_and_loss.conversion_profit_and_losses[1]['conversion_id']).to eq('10c79aba-a9ee-41c2-b0ce-89a0941a8599')
    expect(profit_and_loss.conversion_profit_and_losses[1]['event_type']).to eq('self_service_cancellation')
    expect(profit_and_loss.conversion_profit_and_losses[1]['amount']).to eq('-0.01')
    expect(profit_and_loss.conversion_profit_and_losses[1]['currency']).to eq('GBP')
    end

  it 'can retrieve #date_change_quote' do
    new_settlement_date = '2018-11-29'
    conversion = CurrencyCloud::Conversion.create(conversion_params)

    date_change_quote = conversion.date_change_quote(new_settlement_date: new_settlement_date)

    #date_change_quote = CurrencyCloud::Conversion.date_change_quote('d391e0a1-2643-44ff-b063-bbe39c98a2b5')

    expect(date_change_quote.conversion_id).to eq('d391e0a1-2643-44ff-b063-bbe39c98a2b5')
    expect(date_change_quote.amount).to eq('-0.01')
    expect(date_change_quote.currency).to eq('GBP')
    expect(date_change_quote.new_conversion_date).to eq('2018-11-20T00:00:00+00:00')
    expect(date_change_quote.new_settlement_date).to eq('2018-11-20T16:30:00+00:00')
    expect(date_change_quote.old_conversion_date).to eq('2018-11-19T00:00:00+00:00')
    expect(date_change_quote.old_settlement_date).to eq('2018-11-19T16:30:00+00:00')
    expect(date_change_quote.event_date_time).to eq('2018-11-15T14:08:01+00:00')
  end
end
