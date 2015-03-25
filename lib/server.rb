require_relative 'currency_cloud'

require 'sinatra'

get '/conversion' do
  conversion = CurrencyCloud::Conversion.create({
    buy_currency: params[:buy_currency], 
    sell_currency: params[:sell_currency],
    amount: params[:amount], 
    fixed_side: 'buy', 
    reason: 'test', 
    term_agreement: true
  })
  "Conversion created: #{conversion.short_reference}"
end