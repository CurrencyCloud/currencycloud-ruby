module CurrencyCloud
  module Resources
    class Payment
      include CurrencyCloud::Resource

      resource :payments
      actions :create, :retrieve, :find, :delete, :update
    end
  end
end
