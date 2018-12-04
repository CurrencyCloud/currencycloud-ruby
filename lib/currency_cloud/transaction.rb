module CurrencyCloud
  class Transaction
    include CurrencyCloud::Resource

    resource :transactions
    actions :retrieve, :find

    def self.retrieve_sender_details(sender_id)
      response = client.get("sender/#{sender_id}")
      SenderDetailsResult.new(response)
    end
  end
end
