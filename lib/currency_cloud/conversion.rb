module CurrencyCloud
  class Conversion
    include CurrencyCloud::Resource

    resource :conversions
    actions :create, :retrieve, :find


    def self.cancel(conversion_id:, notes: nil)
      attrs = client.post("#{conversion_id}/cancel", notes: notes)
      new(attrs)
    end

    def self.date_change(conversion_id:, new_settlement_date:)
      attrs = client.post("#{conversion_id}/date_change", new_settlement_date: new_settlement_date)
      new(attrs)
    end

    def self.split(conversion_id:, amount:)
      attrs = client.post("#{conversion_id}/split", amount: amount)
      new(attrs)
    end
  end
end
