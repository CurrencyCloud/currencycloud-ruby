require "spec_helper"

describe "Accounts", vcr: true do
  before do
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
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
end
