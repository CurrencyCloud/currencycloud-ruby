module CurrencyCloud
  class Balance
    include CurrencyCloud::Resource

    resource :balances
    actions :find

    def self.currency(ccy)
      new(client.get(ccy))
    end

    def self.top_up_margin(params)
      top_up = client.post("top_up_margin", params)
      MarginBalanceTopUp.new(top_up)
    end
  end
end
