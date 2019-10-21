module CurrencyCloud
  class Reference
    include CurrencyCloud::Resource

    resource :reference

    def self.beneficiary_required_details(params = {})
      client.get('beneficiary_required_details', params)['details']
    end

    def self.conversion_dates(params)
      dates = client.get('conversion_dates', params)
      ConversionDates.new(dates)
    end

    def self.currencies
      response = client.get('currencies')
      response['currencies'].map { |c| Currency.new(c) }
    end

    def self.payer_required_details(params)
      response = client.get('payer_required_details', params)
      response['details'].map { |prd| PayerRequiredDetails.new(prd) }
    end

    def self.payment_dates(params)
      dates = client.get('payment_dates', params)
      PaymentDates.new(dates)
    end

    def self.payment_purpose_codes(params)
      response = client.get('payment_purpose_codes', params)
      response['purpose_codes'].map { |pc| PurposeCode.new(pc) }
    end

    def self.settlement_accounts(params = {})
      response = client.get('settlement_accounts', params)
      response['settlement_accounts'].map { |s| SettlementAccount.new(s) }
    end

    def self.bank_details(params = {})
      bank_details = client.get('bank_details', params)
      BankDetails.new(bank_details)
    end

    def self.payment_fee_rules(params = {})
      response = client.get('payment_fee_rules', params)
      response['payment_fee_rules'].map { |s| PaymentFeeRule.new(s) }
    end

  end
end
