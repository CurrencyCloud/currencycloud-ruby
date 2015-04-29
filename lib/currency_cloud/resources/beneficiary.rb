module CurrencyCloud
  
  class Beneficiary < Resource
    
    resource :beneficiaries
    
    actions :create, :retrieve, :find, :update, :delete
    
    def self.validate(params)
      new(request.get("#{self.resource}/validate", params))
    end
        
  end
end