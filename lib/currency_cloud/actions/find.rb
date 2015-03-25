module CurrencyCloud
  module Actions
    
    module Find

       def find(params={})
         response = CurrencyCloud.request(:get, "#{self.resource}/find", params)
         unless CurrencyCloud.const_defined?(self.resource.capitalize)
           CurrencyCloud.const_set(self.resource.capitalize, Class.new(CurrencyCloud::ResourcefulCollection))
         end
         CurrencyCloud.const_get(self.resource.capitalize).new(self.resource, self, response)
       end
       
       def first(params={})
         response = CurrencyCloud.request(:get, "#{self.resource}/find", params.merge(per_page: 1))
         if first_result = response[self.resource.to_s].first
           new(first_result)
         else
           nil
         end
       end
       
    end
    
  end
end