module CurrencyCloud
  class Transaction < Resource
    resource :transactions
    
    actions :retrieve, :find
  end
end