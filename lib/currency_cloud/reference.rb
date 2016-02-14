module CurrencyCloud
  class Reference
    include CurrencyCloud::Resource

    resource :reference

    def self.currencies(session = CurrencyCloud.session)
      response = client(session).get("currencies")
      response['currencies'].map { |c| Currency.new(c)}
    end

    def self.beneficiary_required_details(params={}, session = CurrencyCloud.session)
      client(session).get("beneficiary_required_details", params)["details"]
    end

    def self.conversion_dates(params, session = CurrencyCloud.session)
      dates = client(session).get("conversion_dates", params)
      ConversionDates.new(dates)
    end

    def self.settlement_accounts(params={}, session = CurrencyCloud.session)
      response = client(session).get("settlement_accounts", params)
      response['settlement_accounts'].map { |s| SettlementAccount.new(s) }
    end
  end
end
