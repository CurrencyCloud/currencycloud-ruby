module CurrencyCloud
  
  class Payment < Resource
    
    resource :payments
    
    actions :create, :retrieve, :find, :delete, :update
    
    #TODO: authorize, authorizations
  end
end