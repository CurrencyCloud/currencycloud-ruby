module CurrencyCloud
  
  class Reference < Resource
    
    resource :reference

    def self.currencies
      new(request.get("#{self.resource}/currencies"))
    end
    
  end
end