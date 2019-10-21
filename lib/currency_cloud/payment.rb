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

    def confirmation(params = {})
      result = client.get("#{id}/confirmation", params)
      PaymentConfirmationResult.new(result)
    end

    def self.payment_delivery_date(params)
      result = client.get("payment_delivery_date", params)
      PaymentDeliveryDateResult.new(result)
    end

    def self.quote_payment_fee(params)
      result = client.get("quote_payment_fee", params)
      QuotePaymentFee.new(result)
    end

  end
end
