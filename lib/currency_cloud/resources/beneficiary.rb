module CurrencyCloud
  
  class Beneficiary < Resource
    
    resource :beneficiaries
    
    actions :create, :retrieve, :find, :update, :delete
    
    def self.validate(params)
      post('validate', params)
    end        
  end
end