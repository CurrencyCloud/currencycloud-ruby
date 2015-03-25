module CurrencyCloud
  
  class MultipleRates < ResourcefulObject
    
    def self.get(params)
      response = CurrencyCloud.request(:get, 'rates/find', params)
      new(response)
    end 
    
  end
end