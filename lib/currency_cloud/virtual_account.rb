module CurrencyCloud
  class VirtualAccount
    include CurrencyCloud::Resource

    resource :virtual_accounts

    def self.find(params = {})
      result = client.get('/', params)
      VirtualAccounts.new(:virtual_accounts, self, result)
    end

    def self.for_subaccount(subaccount_id, params = {})
      result = client.get("subaccounts/#{subaccount_id}", params)
      VirtualAccounts.new(:virtual_accounts, self, result)
    end

    def self.for_subaccounts(params = {})
      result = client.get("subaccounts/find", params)
      VirtualAccounts.new(:virtual_accounts, self, result)
    end
  end
end
