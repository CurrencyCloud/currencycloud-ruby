module CurrencyCloud
  class Transfer
    include CurrencyCloud::Resource

    resource :transfers
    actions :create, :retrieve, :find, :cancel
  end
end
