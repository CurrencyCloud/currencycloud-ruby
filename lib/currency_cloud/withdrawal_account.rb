module CurrencyCloud
  class WithdrawalAccount
    include CurrencyCloud::Resource

    resource :withdrawal_accounts

    def self.find(params = {})
      result = client.get("/", params)
      WithdrawalAccounts.new(:withdrawal_accounts, self, result)
    end

    def self.pull_funds(withdrawal_account_id, params = {})
      result = client.post("#{withdrawal_account_id}/pull_funds", params)
      WithdrawalAccountFunds.new(result)
    end
  end
end
