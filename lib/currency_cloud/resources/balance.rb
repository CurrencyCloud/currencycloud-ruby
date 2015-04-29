module CurrencyCloud
  class Balance < Resource
    resource :balances
    actions :find

    #TODO: currency
  end
end