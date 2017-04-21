module CurrencyCloud
  class Rate
    include CurrencyCloud::Resource

    resource :rates

    def self.find(params)
      response = client.get('find', params)

      rates = response['rates'].map do |currency_pair, (bid, offer)|
        new(currency_pair: currency_pair, bid: bid, offer: offer)
      end

      Rates.new(currencies: rates, unavailable: response['unavailable'])
    end

    def self.detailed(params)
      new(client.get('detailed', params))
    end
  end
end
