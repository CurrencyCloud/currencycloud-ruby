require "spec_helper"

describe "Accounts", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it "can retrieve #account_payment_charges_settings" do

    settings = CurrencyCloud::Account.get_payment_charges_settings("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(settings.count).to eq(2)

    settings1 = settings[0]
    expect(settings1).to be_a_kind_of(CurrencyCloud::AccountPaymentChargesSetting)
    expect(settings1.charge_settings_id).to eq("090baf7e-5chh-4bfd-9b7l-ad3f8a310123")
    expect(settings1.account_id).to eq("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(settings1.charge_type).to eq("ours")
    expect(settings1.enabled).to eq(false)
    expect(settings1.default).to eq(false)

    settings2 = settings[1]
    expect(settings2).to be_a_kind_of(CurrencyCloud::AccountPaymentChargesSetting)
    expect(settings2.charge_settings_id).to eq("12345678-24b5-4af3-b88f-3aa27de4c6ba")
    expect(settings2.account_id).to eq("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(settings2.charge_type).to eq("shared")
    expect(settings2.enabled).to eq(true)
    expect(settings2.default).to eq(true)
  end

  it "can update #account_payment_charges_settings" do

    params = {enabled: true, default: true}
    updated = CurrencyCloud::Account.update_payment_charges_settings("3e12053j-ae22-40b1-cc4e-cc0230c009a5",
                                                                      "090baf7e-5chh-4bfd-9b7l-ad3f8a310123",
                                                                      params)

    expect(updated).to be_a_kind_of(CurrencyCloud::AccountPaymentChargesSetting)
    expect(updated.charge_settings_id).to eq("090baf7e-5chh-4bfd-9b7l-ad3f8a310123")
    expect(updated.account_id).to eq("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(updated.charge_type).to eq("ours")
    expect(updated.enabled).to eq(true)
    expect(updated.default).to eq(true)
  end

  it "get_compliance_settings" do
    settings = CurrencyCloud::Account.get_compliance_settings("3e12053j-ae22-40b1-cc4e-cc0230c009a5")

    expect(settings).to be_a_kind_of(CurrencyCloud::AccountComplianceSetting)
    expect(settings.account_id).to eq("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(settings.industry_type).to eq('some-type')
    expect(settings.country_of_incorporation).to eq('US')
    expect(settings.date_of_incorporation).to eq('2020-01-30')
    expect(settings.business_website_url).to eq('no_website_available')
    expect(settings.expected_transaction_countries).to eq(['US', 'GB'])
    expect(settings.expected_transaction_currencies).to eq(['GBP'])
    expect(settings.expected_monthly_activity_volume).to eq(10)
    expect(settings.expected_monthly_activity_value).to eq('30.00')
    expect(settings.tax_identification).to eq('some-tax-id')
    expect(settings.national_identification).to eq('some-national-id')
    expect(settings.country_of_citizenship).to eq('US')
    expect(settings.trading_address_street).to eq('some-street')
    expect(settings.trading_address_city).to eq('some-city')
    expect(settings.trading_address_state).to eq('NY')
    expect(settings.trading_address_postalcode).to eq('90210')
    expect(settings.trading_address_country).to eq('US')
    expect(settings.customer_risk).to eq('LOW')
  end

  it "update_compliance_settings" do
    params = {
      "industry_type" => "some-type",
      "country_of_incorporation" => "US",
      "date_of_incorporation" => "2020-01-30",
      "business_website_url" => "no_website_available",
      "expected_transaction_countries" => ["US", "GB"],
      "expected_transaction_currencies" => ["GBP"],
      "expected_monthly_activity_volume" => 10,
      "expected_monthly_activity_value" => "30.00",
      "tax_identification" => "some-tax-id",
      "national_identification" => "some-national-id",
      "country_of_citizenship" => "US",
      "trading_address_street" => "some-street",
      "trading_address_city" => "some-city",
      "trading_address_state" => "NY",
      "trading_address_postalcode" => "90210",
      "trading_address_country" => "US",
      "customer_risk" => "LOW"
    }

    settings = CurrencyCloud::Account.update_compliance_settings("3e12053j-ae22-40b1-cc4e-cc0230c009a5", params)

    expect(settings).to be_a_kind_of(CurrencyCloud::AccountComplianceSetting)
    expect(settings.account_id).to eq("3e12053j-ae22-40b1-cc4e-cc0230c009a5")
    expect(settings.industry_type).to eq('some-type')
    expect(settings.country_of_incorporation).to eq('US')
    expect(settings.date_of_incorporation).to eq('2020-01-30')
    expect(settings.business_website_url).to eq('no_website_available')
    expect(settings.expected_transaction_countries).to eq(['US', 'GB'])
    expect(settings.expected_transaction_currencies).to eq(['GBP'])
    expect(settings.expected_monthly_activity_volume).to eq(10)
    expect(settings.expected_monthly_activity_value).to eq('30.00')
    expect(settings.tax_identification).to eq('some-tax-id')
    expect(settings.national_identification).to eq('some-national-id')
    expect(settings.country_of_citizenship).to eq('US')
    expect(settings.trading_address_street).to eq('some-street')
    expect(settings.trading_address_city).to eq('some-city')
    expect(settings.trading_address_state).to eq('NY')
    expect(settings.trading_address_postalcode).to eq('90210')
    expect(settings.trading_address_country).to eq('US')
    expect(settings.customer_risk).to eq('LOW')
  end
end

