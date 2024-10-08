module CurrencyCloud
  class Screening
    include CurrencyCloud::Resource

    resource :collections_screening

    def self.complete(transaction_id, params = {})
      result = client.put("#{transaction_id}/complete", params)
      CollectionsScreening.new(result)
    end

  end
end