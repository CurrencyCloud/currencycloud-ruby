module CurrencyCloud
  
  class DetailedRate < ResourcefulObject
    
    def self.get(params)
      response = CurrencyCloud.request(:get, 'rates/detailed', params)
      new(response)
    end 
    
  end
end