module CurrencyCloud
  module Resources
    class Payer
      include CurrencyCloud::Resource

      resource :payers
      actions :retrieve
    end
  end
end
