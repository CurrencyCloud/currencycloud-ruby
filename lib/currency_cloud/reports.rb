module CurrencyCloud
  class Reports
    include CurrencyCloud::Resource

    resource :reports
    actions :retrieve, :find

    def self.create_conversions_report(params = {})
      response = client.post('conversions/create', params)
      ConversionReportResult.new(response)
    end
  end
end