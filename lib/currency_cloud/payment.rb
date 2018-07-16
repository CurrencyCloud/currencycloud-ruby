module CurrencyCloud
  class Payment
    include CurrencyCloud::Resource

    resource :payments
    actions :create, :retrieve, :find, :delete, :update

    def submission(params = {})
      attrs = client.get("#{id}/submission", params)
      PaymentSubmission.new(attrs)
    end
  end
end
