module CurrencyCloud
  class IBAN
    include CurrencyCloud::Resource

    resource :ibans

    def self.find(params = {})
      result = client.get('/', params)
      IBANs.new(:ibans, self, result)
    end

    def self.for_subaccount(subaccount_id, params = {})
      result = client.get("subaccounts/#{subaccount_id}", params)
      IBANs.new(:ibans, self, result)
    end

    def self.for_subaccounts(params = {})
      result = client.get('subaccounts/find', params)
      IBANs.new(:ibans, self, result)
    end
  end
end
