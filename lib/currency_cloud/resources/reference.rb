module CurrencyCloud
  
  class Currency < Resource; end
  class ConversionDates < Resource; end
  class SettlementAccount < Resource; end

  class Reference < Resource
    
    resource :reference

    def self.currencies
      response = request.get(build_url("currencies"))
      response['currencies'].map { |c| Currency.new(c)}
    end

    def self.beneficiary_required_details(params={})
      request.get(build_url("beneficiary_required_details"), params)['details']
    end

    def self.conversion_dates(params)
      ConversionDates.new(request.get(build_url("conversion_dates"), params))
    end

    def self.settlement_accounts(params={})
      response = request.get(build_url("settlement_accounts"), params)
      response['settlement_accounts'].map { |s| SettlementAccount.new(s)}
    end
  end
end