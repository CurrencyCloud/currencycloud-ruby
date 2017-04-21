require 'spec_helper'

describe 'Settlements', vcr: true do
  before(:all) do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = '6f5f99d1b860fc47e8a186e3dce0d3f9'

    @params = {
      buy_currency: 'GBP',
      sell_currency: 'USD',
      fixed_side: 'buy',
      amount: 1000,
      reason: 'mortgage payment',
      term_agreement: true
    }
  end

  it 'can #add_conversion' do
    conversion = CurrencyCloud::Conversion.create(@params)
    settlement = CurrencyCloud::Settlement.create

    updated_settlement = settlement.add_conversion(conversion.id)

    expect(settlement).to eq(updated_settlement)

    expect(settlement.conversion_ids).to eq(['24d2ee7f-c7a3-4181-979e-9c58dbace992'])
    expect(settlement.entries).to_not be_empty

    gbp_currency = settlement.entries[0]
    expect(gbp_currency).to include('GBP' => { 'receive_amount' => '1000.00', 'send_amount' => '0.00' })

    usd_currency = settlement.entries[1]
    expect(usd_currency).to include('USD' => { 'receive_amount' => '0.00', 'send_amount' => '1511.70' })

    expect(settlement.updated_at).to eq('2015-05-04T20:40:56+00:00')
  end

  it 'can #remove_conversion' do
    settlement = CurrencyCloud::Settlement.retrieve('63eeef54-3531-4e65-827a-7d0f37503fcc')
    deleted_settlement = settlement.remove_conversion('24d2ee7f-c7a3-4181-979e-9c58dbace992')

    expect(deleted_settlement).to_not be_nil
    expect(deleted_settlement.type).to eq('bulk')
    expect(deleted_settlement.created_at).to eq('2015-05-04T20:29:16+00:00')
    expect(deleted_settlement.status).to eq('open')
  end

  it 'can #release' do
    settlement = CurrencyCloud::Settlement.retrieve('51c619e0-0256-40ad-afba-ca4114b936f9')
    released_settlement = settlement.release

    expect(released_settlement).to eq(settlement)
    expect(released_settlement.released_at).to eq('2015-05-04T21:44:23+00:00')
    expect(released_settlement.status).to eq('released')
  end

  it 'can #unrelease' do
    settlement = CurrencyCloud::Settlement.retrieve('51c619e0-0256-40ad-afba-ca4114b936f9')
    unreleased_settlement = settlement.unrelease

    expect(unreleased_settlement).to eq(settlement)
    expect(unreleased_settlement.released_at).to eq('')
    expect(unreleased_settlement.status).to eq('open')
  end
end
