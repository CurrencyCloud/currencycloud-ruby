module CurrencyCloud
  class Reference
    include CurrencyCloud::Resource

    resource :reference

    def self.currencies
      response = client.get('currencies')
      response['currencies'].map { |c| Currency.new(c) }
    end

    def self.beneficiary_required_details(params = {})
      client.get('beneficiary_required_details', params)['details']
    end

    def self.conversion_dates(params)
      dates = client.get('conversion_dates', params)
      ConversionDates.new(dates)
    end

    def self.settlement_accounts(params = {})
      response = client.get('settlement_accounts', params)
      response['settlement_accounts'].map { |s| SettlementAccount.new(s) }
    end
  end
end
