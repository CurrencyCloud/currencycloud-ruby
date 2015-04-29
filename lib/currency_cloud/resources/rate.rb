module CurrencyCloud
  class Rates < Resource; end

  class Rate < Resource
    resource :rates
    
    def self.find(params)
      response = request.get("#{self.resource}/find", params)

      rates = response['rates'].map do |currency_pair, bid_offer|
                new(currency_pair: currency_pair, bid: bid_offer[0], offer: bid_offer[1])
              end

      Rates.new(currencies: rates, unavailable: response['unavailable'])
    end

    def self.detailed(params)
      get('detailed', params)
    end
  end
end