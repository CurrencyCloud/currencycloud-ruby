require 'spec_helper'

describe 'CollectionsScreening', vcr: true do
  before do
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end

  it 'can #complete with accepted true' do
    result = CurrencyCloud::CollectionsScreening.complete(
      'bdcca5e6-32fe-45f6-9476-6f8f518e6270',
      accepted: true,
      reason: 'accepted'
    )

    expect(result).to be_a(CurrencyCloud::CollectionsScreeningResult)
    expect(result.transaction_id).to eq('bdcca5e6-32fe-45f6-9476-6f8f518e6270')
    expect(result.account_id).to eq('7a116d7d-6310-40ae-8d54-0ffbe41dc1c9')
    expect(result.house_account_id).to eq('7a116d7d-6310-40ae-8d54-0ffbe41dc1c9')
    expect(result.result).to be_a(Hash)
    expect(result.result['accepted']).to eq(true)
    expect(result.result['reason']).to eq('accepted')
  end

  it 'can #complete with accepted false' do
    result = CurrencyCloud::CollectionsScreening.complete(
      'cdcca5e6-32fe-45f6-9476-6f8f518e6271',
      accepted: false,
      reason: 'suspected_fraud'
    )

    expect(result).to be_a(CurrencyCloud::CollectionsScreeningResult)
    expect(result.transaction_id).to eq('cdcca5e6-32fe-45f6-9476-6f8f518e6271')
    expect(result.account_id).to eq('8b227e8e-7421-51bf-9e65-1ggge51ed2d0')
    expect(result.house_account_id).to eq('8b227e8e-7421-51bf-9e65-1ggge51ed2d0')
    expect(result.result).to be_a(Hash)
    expect(result.result['accepted']).to eq(false)
    expect(result.result['reason']).to eq('suspected_fraud')
  end
end
