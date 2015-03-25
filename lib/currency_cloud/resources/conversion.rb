module CurrencyCloud
  
  class Conversion < ResourcefulObject
    
    resource :conversions
    
    actions :create, :retrieve, :find

  end
end