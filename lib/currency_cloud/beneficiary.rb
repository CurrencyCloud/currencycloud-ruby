module CurrencyCloud
  class Beneficiary
    include CurrencyCloud::Resource

    resource :beneficiaries
    actions :create, :retrieve, :find, :update, :delete

    def self.validate(params, session = CurrencyCloud.session)
      new(client(session).post("validate", params))
    end
  end
end
