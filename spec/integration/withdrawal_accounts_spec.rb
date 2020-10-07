require "spec_helper"

describe "WithdrawalAccounts", vcr: true do
  before do
    CurrencyCloud.login_id = "development@currencycloud.com"
    CurrencyCloud.api_key = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end


  it "can find #withdrawal_accounts" do
    withdrawal_accounts = CurrencyCloud::WithdrawalAccount.find(
        account_id: "72970a7c-7921-431c-b95f-3438724ba16f"
    )
    expect(withdrawal_accounts.length).to eq(1)

    withdrawal_account = withdrawal_accounts[0]
    expect(withdrawal_account).to be_a(CurrencyCloud::WithdrawalAccount)
    expect(withdrawal_account.id).to eq("0886ac00-6ab6-41a6-b0e1-8d3faf2e0de2")
    expect(withdrawal_account.account_name).to eq("currencycloud")
    expect(withdrawal_account.account_holder_name).to eq("The Currency Cloud")
    expect(withdrawal_account.account_holder_dob).to be_nil
    expect(withdrawal_account.routing_code).to eq("123456789")
    expect(withdrawal_account.account_number).to eq("01234567890")
    expect(withdrawal_account.currency).to eq("USD")
    expect(withdrawal_account.account_id).to eq("72970a7c-7921-431c-b95f-3438724ba16f")
  end

  it "can find #withdrawal_accounts2" do
    withdrawal_accounts = CurrencyCloud::WithdrawalAccount.find()
    expect(withdrawal_accounts.length).to eq(2)

    withdrawal_account1 = withdrawal_accounts[0]
    expect(withdrawal_account1).to be_a(CurrencyCloud::WithdrawalAccount)
    expect(withdrawal_account1.id).to eq("0886ac00-6ab6-41a6-b0e1-8d3faf2e0de2")
    expect(withdrawal_account1.account_name).to eq("currencycloud")
    expect(withdrawal_account1.account_holder_name).to eq("The Currency Cloud")
    expect(withdrawal_account1.account_holder_dob).to be_nil
    expect(withdrawal_account1.routing_code).to eq("123456789")
    expect(withdrawal_account1.account_number).to eq("01234567890")
    expect(withdrawal_account1.currency).to eq("USD")
    expect(withdrawal_account1.account_id).to eq("72970a7c-7921-431c-b95f-3438724ba16f")

    withdrawal_account2 = withdrawal_accounts[1]
    expect(withdrawal_account2).to be_a(CurrencyCloud::WithdrawalAccount)
    expect(withdrawal_account2.id).to eq("0886ac00-6ab6-41a6-b0e1-8d3faf2e0de3")
    expect(withdrawal_account2.account_name).to eq("currencycloud2")
    expect(withdrawal_account2.account_holder_name).to eq("The Currency Cloud 2")
    expect(withdrawal_account2.account_holder_dob).to eq("1990-07-20")
    expect(withdrawal_account2.routing_code).to eq("223456789")
    expect(withdrawal_account2.account_number).to eq("01234567892")
    expect(withdrawal_account2.currency).to eq("GBP")
    expect(withdrawal_account2.account_id).to eq("72970a7c-7921-431c-b95f-3438724ba16e")
  end

  it "can pull funds" do
    withdrawal_account_funds = CurrencyCloud::WithdrawalAccount.pull_funds(
        "0886ac00-6ab6-41a6-b0e1-8d3faf2e0de2",
        reference: "PullFunds1",
        amount: 100.0
    )
    expect(withdrawal_account_funds).to be_a(CurrencyCloud::WithdrawalAccountFunds)
    expect(withdrawal_account_funds.id).to eq("e2e6b7aa-c9e8-4625-96a6-b97d4baab758")
    expect(withdrawal_account_funds.withdrawal_account_id).to eq("0886ac00-6ab6-41a6-b0e1-8d3faf2e0de2")
    expect(withdrawal_account_funds.reference).to eq("PullFunds1")
    expect(withdrawal_account_funds.amount).to eq("100.00")
    expect(withdrawal_account_funds.created_at).to eq("2020-06-29T08:02:31+00:00")
  end
end
