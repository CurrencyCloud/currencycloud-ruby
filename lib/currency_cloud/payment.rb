module CurrencyCloud
  class Payment
    include CurrencyCloud::Resource

    resource :payments
    actions :create, :retrieve, :find, :delete, :update

    def submission_info(params = {})
      result = client.get("#{id}/submission_info", params)
      PaymentSubmissionInfo.new(result)
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

    def self.tracking_info(id)
      result = client.get("#{id}/tracking_info")
      PaymentTrackingInfo.new(result)
    end

    def self.validate(params, sca_to_authenticated_user = false)
      headers = { 'x-sca-to-authenticated-user' => sca_to_authenticated_user.to_s }
      opts = { headers: headers, return_response_headers: true }
      body, response_headers = client.post("validate", params, opts)
      PaymentValidationResult.new(body, response_headers)
    end

    def self.create(params = {}, sca_id = nil, sca_token = nil)
      # If no SCA values are provided
      return super(params) if sca_id.nil? && sca_token.nil?

      headers = {}
      headers['x-sca-id']    = sca_id unless sca_id.nil?
      headers['x-sca-token'] = sca_token unless sca_token.nil?

      opts  = { headers: headers }
      attrs = client.post("create", params, opts)
      new(attrs)
    end

  end
end
