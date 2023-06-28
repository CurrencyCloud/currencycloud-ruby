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

    def first(params = {})
      entities = find(params.merge(per_page: 1)) || []
      entities.first
    end
  end
end
