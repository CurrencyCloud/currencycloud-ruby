module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :update, :delete
    actions_post :find

    def self.validate(params)
      new(client.post('validate', params))
    end

    def account_verification(params)
      AccountVerification:new(client.post('account_verification', params))
    end
  end
end
