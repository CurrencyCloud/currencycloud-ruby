module CurrencyCloud
  class Payment
    include CurrencyCloud::Resource

    resource :payments
    actions :create, :retrieve, :find, :delete, :update

    def submission(params = {})
      result = client.get("#{id}/submission", params)
      PaymentSubmission.new(result)
    end

    def self.authorise(*ids)
      result = client.post("authorise", payment_ids: ids)['authorisations']
      result.map { |pa| PaymentAuthorisationResult.new(pa) }
    end
  end
end
