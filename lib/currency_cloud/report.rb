module CurrencyCloud
  class Report
    include CurrencyCloud::Resource

    resource :reports
    actions :retrieve, :find

    def self.create_conversion_report(params = {})
      attrs = client.post("conversions/create", params)
      new(attrs)
    end

    def self.create_payment_report(params = {})
      attrs = client.post("payments/create", params)
      new(attrs)
    end
  end
end
