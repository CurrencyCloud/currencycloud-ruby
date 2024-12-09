require "spec_helper"

describe "TermsAndConditions", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it "can accept terms" do
    terms_and_conditions_result = CurrencyCloud::TermAndCondition.accept(
      type: "VGSI",
      version: "1.0",
      first_name: "firstName",
      last_name: "lastName",
      email: "development@currencycloud.com",
      reference_type: "ACCOUNT",
      reference_id: "ebcaee2f-a733-11ef-8de2-0242ac1d0002"
    )
    expect(terms_and_conditions_result).to be_a(CurrencyCloud::TermsAndConditions)
    expect(terms_and_conditions_result.acceptance_id).to eq("1c4667dd-ddea-47e8-a0d7-e39d9cce1a39")
    expect(terms_and_conditions_result.accepted_at).to eq("2024-10-04T15:27:04.052814529")
  end
end