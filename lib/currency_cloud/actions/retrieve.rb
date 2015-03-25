module CurrencyCloud
  module Actions
    
    module Retrieve

       def retrieve(id)
         response = CurrencyCloud.request(:get, "#{self.resource}/#{id}")
         new(response)
       end 
      
    end
    
  end
end