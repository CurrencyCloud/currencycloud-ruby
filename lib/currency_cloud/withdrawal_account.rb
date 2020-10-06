module CurrencyCloud
  class WithdrawalAccount
    include CurrencyCloud::Resource

    resource :withdrawal_accounts

    def self.find(params = {})
      result = client.get('/', params)
      WithdrawalAccounts.new(:withdrawal_accounts, self, result)
    end

    def self.pull_funds(withdrawalAccountId, params = {})
      result = client.post("pull_funds/#{withdrawalAccountId}", params)
      WithdrawalAccountFunds.new(result)
    end

  end
end