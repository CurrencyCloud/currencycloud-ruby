module CurrencyCloud
  class Quote
    include CurrencyCloud::Resource

    resource :quotes
    actions :create
  end
end
