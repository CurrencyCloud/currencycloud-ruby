require "spec_helper"

describe "Screenings", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it "can complete" do
    screening_response = CurrencyCloud::Screening.complete(
      "ae305c98-e46f-465a-b468-f92d39fad977",
      accepted: true,
      reason: "Accepted"
    )
    expect(screening_response).to be_a(CurrencyCloud::ScreeningResponse)
    expect(screening_response.transaction_id).to eq("ae305c98-e46f-465a-b468-f92d39fad977")
    expect(screening_response.account_id).to eq("7a116d7d-6310-40ae-8d54-0ffbe41dc1c9")
    expect(screening_response.house_account_id).to eq("7a116d7d-6310-40ae-8d54-0ffbe41dc1c9")
    expect(screening_response.result.reason).to eq("Accepted")
    expect(screening_response.result.accepted).to eq("true")
  end

end
