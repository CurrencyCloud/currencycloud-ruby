require 'spec_helper'

describe 'Authentication', vcr: true do
  before do
    CurrencyCloud.reset_session
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.login_id = 'rjnienaber@gmail.com'
    CurrencyCloud.api_key = 'ef0fd50fca1fb14c1fab3a8436b9ecb65f02f129fd87eafa45ded8ae257528f0'
    CurrencyCloud.token = nil
  end

  it 'happens lazily' do
    expect(CurrencyCloud.session).to_not be_nil
    expect(CurrencyCloud.session.token).to eq('57ef449f6316f2f54dfec37c2006fe50')
  end

  it 'can use just a token' do
    CurrencyCloud.login_id = nil
    CurrencyCloud.api_key = nil
    CurrencyCloud.token = '7fbba909f66ee6721b2e20a5fa1ccae7'

    response = CurrencyCloud::Beneficiary.find
    expect(response).to_not be_nil
  end

  it 'can be closed' do
    CurrencyCloud.session
    expect(CurrencyCloud.close_session).to eq(true)
  end

  it 'handles session timeout error' do
    CurrencyCloud.token = '3907f05da86533710efc589d58f51f45'

    response = CurrencyCloud::Beneficiary.find
    expect(response).to_not be_nil

    # should have changed after reauthentication
    expect(CurrencyCloud.token).to eq('038022bcd2f372cac7bab448db7b5c3b')
  end
end
