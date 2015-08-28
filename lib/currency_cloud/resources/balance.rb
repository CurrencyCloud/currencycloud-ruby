module CurrencyCloud
  module Resources
    class Balance
      include CurrencyCloud::Resource

      resource :balances
      actions :find

      def self.currency(ccy)
        new(client.get(ccy))
      end
    end
  end
end
