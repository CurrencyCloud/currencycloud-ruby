module CurrencyCloud
  class Conversion
    include CurrencyCloud::Resource

    resource :conversions
    actions :create, :retrieve, :find

    def cancel(params = {})
      attrs = client.post("#{id}/cancel", params)
      ConversionCancelResult.new(attrs)
    end

    def date_change(params)
      attrs = client.post("#{id}/date_change", params)
      ConversionDateChangeResult.new(attrs)
    end

    def split(params)
      attrs = client.post("#{id}/split", params)
      ConversionSplitResult.new(attrs)
    end

    def self.retrieve_profit_and_loss(params = {})
      attrs = client.get("profit_and_loss", params)
      ConversionProfitAndLoss.new(attrs)
    end

    def date_change_quote(params)
      attrs = client.get("#{id}/date_change_quote", params)
      ConversionDateChangeQuoteResult.new(attrs)
    end

    def split_preview(params)
      attrs = client.get("#{id}/split_preview", params)
      ConversionSplitPreviewResult.new(attrs)
    end
  end
end
