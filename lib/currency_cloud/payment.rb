module CurrencyCloud
  class Payment
    include CurrencyCloud::Resource

    resource :payments
    actions :create, :retrieve, :find, :delete, :update
  end
end
