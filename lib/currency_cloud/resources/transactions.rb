module CurrencyCloud
  
  class Transaction < ResourcefulObject
    
    resource :transactions
    
    actions :retrieve, :find
    
  end
end