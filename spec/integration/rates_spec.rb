require 'spec_helper'

describe 'Rates', vcr: true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.token = 'bbdd421bdda373ea69670c9101fa9197'
  end

  it 'can #find' do
    rates = CurrencyCloud::Rate.find(currency_pair: 'GBPUSD,EURGBP')

    expect(rates).to_not be_nil
    expect(rates.currencies).to_not be_empty

    currencies = rates.currencies
    expect(currencies.length).to eq(2)

    currencies.each do |b|
      expect(b).to_not be_nil
      expect(b).to be_a_kind_of(CurrencyCloud::Rate)
    end

    rate = currencies.first
    expect(rate.currency_pair).to eq('EURGBP')
    expect(rate.bid).to eq('0.71445')
    expect(rate.offer).to eq('0.71508')

    expect(rates.unavailable).to be_empty
  end

  it 'can provided #detailed rate' do
    detailed_rate = CurrencyCloud::Rate.detailed(buy_currency: 'GBP', sell_currency: 'USD', fixed_side: 'buy', amount: '10000')

    expect(detailed_rate).to be_a_kind_of(CurrencyCloud::Rate)
    expect(detailed_rate.client_sell_amount).to eq('15234.00')
    expect(detailed_rate.settlement_cut_off_time).to eq('2015-04-29T14:00:00Z')
  end
end
