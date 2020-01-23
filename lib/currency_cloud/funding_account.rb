module CurrencyCloud
  class FundingAccount
    include CurrencyCloud::Resource

    resource :funding_accounts
    actions :find
  end
end