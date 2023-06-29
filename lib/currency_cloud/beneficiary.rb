module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :update, :delete
    actions_post :find

    def self.validate(params)
      new(client.post('validate', params))
    end
  end
end
