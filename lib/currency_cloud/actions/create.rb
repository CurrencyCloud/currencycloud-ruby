module CurrencyCloud
  module Actions
    
    module Create

       def create(params={})
         response = CurrencyCloud.request(:post, "#{self.resource}/create", params)
         new(response)
       end
       
    end
    
  end
end