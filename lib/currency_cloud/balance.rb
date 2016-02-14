module CurrencyCloud
  class Balance
    include CurrencyCloud::Resource

    resource :balances
    actions :find

    def self.currency(ccy, session = CurrencyCloud.session)
      new(client(session).get(ccy))
    end
  end
end
