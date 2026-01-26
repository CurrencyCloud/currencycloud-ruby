module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :update, :delete
    actions_post :find

    def self.validate(params)
      new(client.post('validate', params))
    end

    def self.verify_account(params)
      attrs = client.post('account_verification', params)
      BeneficiaryAccountVerificationResult.new(attrs)
    end
  end
end
