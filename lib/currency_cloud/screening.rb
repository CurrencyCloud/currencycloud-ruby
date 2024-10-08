module CurrencyCloud
  class Screening
    include CurrencyCloud::Resource

    resource :screening_response

    def self.complete(transaction_id, params = {})
      result = client.put("#{transaction_id}/complete", params)
      ScreeningResponse.new(result)
    end

  end
end