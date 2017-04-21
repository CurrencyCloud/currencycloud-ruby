module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :find, :update, :delete

    def self.validate(params)
      new(client.post('validate', params))
    end
  end
end
