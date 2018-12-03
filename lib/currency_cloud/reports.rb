module CurrencyCloud
  class Reports
    include CurrencyCloud::Resource

    resource :reports
    actions :retrieve, :find

    def self.create_conversions_report(params = {})
      response = client.post('conversions/create', params)
      ConversionReportResult.new(response)
    end

    def self.create_payments_report(params = {})
      response = client.post('payments/create', params)
      PaymentReportResult.new(response)
    end

    def self.find_report_requests(params = {})
      response = client.get('report_requests/find', params)
      ReportRequestsResult.new(response)
    end
  end
end