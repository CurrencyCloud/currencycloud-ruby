module CurrencyCloud
  class Balance < Resource
    resource :balances
    actions :find

    def self.currency(ccy)
      get(ccy)
    end
  end
end