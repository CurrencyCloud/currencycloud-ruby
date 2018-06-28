module CurrencyCloud
  class Conversion
    include CurrencyCloud::Resource

    resource :conversions
    actions :create, :retrieve, :find

    def self.cancel(id, params)
      attrs = client.post("#{id}/cancel", params)
      new(attrs)
    end

    def self.date_change(id, params)
      attrs = client.post("#{id}/date_change", params)
      new(attrs)
    end

    def self.split(id, params)
      attrs = client.post("#{id}/split", params)
      new(attrs)
    end
  end
end
