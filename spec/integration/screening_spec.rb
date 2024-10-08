require "spec_helper"

describe "Screenings", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it "can complete" do
    collections_screening = CurrencyCloud::Screening.complete(
      "ae305c98-e46f-465a-b468-f92d39fad977",
      accepted: true,
      reason: "Accepted"
    )
    expect(collections_screening).to be_a(CurrencyCloud::CollectionsScreening)
    expect(collections_screening.transaction_id).to eq("ae305c98-e46f-465a-b468-f92d39fad977")
    expect(collections_screening.account_id).to eq("7a116d7d-6310-40ae-8d54-0ffbe41dc1c9")
    expect(collections_screening.house_account_id).to eq("7a116d7d-6310-40ae-8d54-0ffbe41dc1c9")

    #result = collections_screening.result
    #expect(result.reason).to eq("Accepted")
    #expect(collections_screening.result.accepted).to eq(true)
  end

end
