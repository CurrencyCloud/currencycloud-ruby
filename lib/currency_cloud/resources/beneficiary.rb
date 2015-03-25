module CurrencyCloud
  
  class Beneficiary < ResourcefulObject
    
    resource :beneficiaries
    
    actions :create, :retrieve, :find
    
    def self.validate(params)
      response = CurrencyCloud.request(:post, "#{self.resource}/validate", params)
      new(response)
    end
        
  end
end