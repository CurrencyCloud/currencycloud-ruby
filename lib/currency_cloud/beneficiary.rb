module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :update, :delete

    def self.validate(params)
      new(client.post('validate', params))
    end

    def self.find(params)
      client.post('find', params)
    end
  end
end
