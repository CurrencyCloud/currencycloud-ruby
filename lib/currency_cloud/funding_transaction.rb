module CurrencyCloud
  class FundingTransaction
    include CurrencyCloud::Resource

    resource :funding_transactions
    actions :retrieve
  end
end
