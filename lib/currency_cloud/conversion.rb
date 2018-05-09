module CurrencyCloud
  class Conversion
    include CurrencyCloud::Resource

    resource :conversions
    actions :create, :retrieve, :find

    def self.cancel(params)
      attrs = client.post("#{params[:conversion_id]}/cancel", params.delete_if{|key, _value| key == :conversion_id})
      new(attrs)
    end

    def self.date_change(params)
      attrs = client.post("#{params[:conversion_id]}/date_change", params.delete_if{|key, _value| key == :conversion_id})
      new(attrs)
    end

    def self.split(params)
      attrs = client.post("#{params[:conversion_id]}/split", params.delete_if{|key, _value| key == :conversion_id})
      new(attrs)
    end
  end
end
