require "spec_helper"

describe "FundingAccounts", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end
  it 'can #find' do

    accounts = CurrencyCloud::FundingAccount.find(currency: 'GBP', per_page: 5)
    expect(accounts.length).to eq 1

    account = accounts[0]
    expect(account).to be_a(CurrencyCloud::FundingAccount)
    expect(account.id).to eq "b7981972-8e29-485b-8a4a-9643fc6ae3sa"
    expect(account.account_id).to eq "8d98bdc8-e8e3-47dc-bd08-3dd0f4f7ea7b"
    expect(account.account_number).to eq "012345678"
    expect(account.account_number_type).to eq "account_number"
    expect(account.account_holder_name).to eq "Jon Doe"
    expect(account.bank_name).to eq "Starling"
    expect(account.bank_address).to eq "3rd floor, 2 Finsbury Avenue, London, EC2M 2PP, GB"
    expect(account.bank_country).to eq "UK"
    expect(account.currency).to eq "GBP"
    expect(account.payment_type).to eq "regular"
    expect(account.routing_code).to eq "010203"
    expect(account.routing_code_type).to eq "sort_code"
    expect(account.created_at).to eq "2018-05-14T14:18:30+00:00"
    expect(account.updated_at).to eq "2018-05-14T14:19:30+00:00"
  end

  it "can find #missing_currency" do
    begin
      accounts = CurrencyCloud::FundingAccount.find()
    rescue CurrencyCloud::BadRequestError => error
      # All Good. Expected
      expect(error.messages.length).to eq 1
      expect(error.messages[0].code).to eq "currency_is_required"
    end
  end

  it "can find #bad_request" do
    begin
      accounts = CurrencyCloud::FundingAccount.find(currency: "a", payment_type: "x", account_id: "x")
    rescue CurrencyCloud::BadRequestError => error
      # All Good. Expected
      expect(error.messages.length).to eq 3
    end
  end

  it "can find #unauthorized" do
    begin
      accounts = CurrencyCloud::FundingAccount.find(currency: "GBP")
    rescue CurrencyCloud::AuthenticationError => error
      # All Good. Expected
      expect(error.messages.length).to eq 1
      expect(error.messages[0].code).to eq "invalid_supplied_credentials"
    end
  end

end