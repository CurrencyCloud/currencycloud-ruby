module CurrencyCloud
  class CollectionsScreening
    include CurrencyCloud::Resource

    resource :collections_screening

    def self.complete(transaction_id, params = {})
      response = client.put("#{transaction_id}/complete", params)
      CollectionsScreeningResult.new(response)
    end
  end
end
