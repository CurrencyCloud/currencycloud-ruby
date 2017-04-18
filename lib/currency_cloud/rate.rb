module CurrencyCloud
  class Rate
    include CurrencyCloud::Resource

    resource :rates

    def self.find(params, session = CurrencyCloud.session)
      response = client(session).get("find", params)

      rates = response["rates"].map do |currency_pair, (bid, offer)|
        new(currency_pair: currency_pair, bid: bid, offer: offer)
      end

      Rates.new(currencies: rates, unavailable: response["unavailable"])
    end

    def self.detailed(params, session = CurrencyCloud.session)
      new(client(session).get("detailed", params))
    end
  end
end
