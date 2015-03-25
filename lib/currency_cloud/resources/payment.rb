module CurrencyCloud
  
  class Payment < ResourcefulObject
    
    resource :payments
    
    actions :create, :retrieve, :find, :delete, :update
    
  end
end