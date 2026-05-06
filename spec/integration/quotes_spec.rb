require 'spec_helper'

describe 'Quotes', vcr: true do
  let(:quote_params) do
    {
      buy_currency: 'USD',
      sell_currency: 'EUR',
      fixed_side: 'sell',
      amount: '100.0',
      hold_period: '30s'
    }
  end

  it 'can create a held rate quote' do
    quote = CurrencyCloud::Quote.create(quote_params)

    expect(quote).to be_a(CurrencyCloud::Quote)
    expect(quote.quote_id).not_to be_nil
    expect(quote.buy_currency).to eq('USD')
    expect(quote.sell_currency).to eq('EUR')
    expect(quote.fixed_side).to eq('sell')
    expect(quote.expires_at).not_to be_nil
    expect(quote.client_rate).not_to be_nil
    expect(quote.client_buy_amount).not_to be_nil
    expect(quote.client_sell_amount).to eq('100.0')
  end

  it 'can create a quote with conversion_date' do
    params = quote_params.merge(conversion_date: (Date.today + 2).to_s)
    quote = CurrencyCloud::Quote.create(params)

    expect(quote).to be_a(CurrencyCloud::Quote)
    expect(quote.quote_id).not_to be_nil
  end

  it 'can create a quote with conversion_date_preference' do
    params = quote_params.merge(conversion_date_preference: 'earliest')
    quote = CurrencyCloud::Quote.create(params)

    expect(quote).to be_a(CurrencyCloud::Quote)
    expect(quote.quote_id).not_to be_nil
  end
end
