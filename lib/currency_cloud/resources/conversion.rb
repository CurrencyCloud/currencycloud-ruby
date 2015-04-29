module CurrencyCloud
  
  class Conversion < Resource
    
    resource :conversions
    
    actions :create, :retrieve, :find

  end
end