module CurrencyCloud
  class FundingTransactions
    include CurrencyCloud::Resource

    resource :funding_transactions
    actions :retrieve

    def self.retrieve_funding_transaction(transaction_id)
      response = client.get("#{transaction_id}")
      FundingTransactionResult.new(response)
    end
  end
end
