require 'spec_helper'

describe 'RequestHandler' do
  let(:session) { CurrencyCloud::Session.new(:demonstration, nil, nil, '4df5b3e5882a412f148dcd08fa4e5b73')}
  let(:response) { double('Response', code: 200, body: '{}') }

  subject { CurrencyCloud::RequestHandler.new(session) }

  describe 'with on_behalf_of parameter' do
    it "adds it to parameters in HTTP call" do
      session.on_behalf_of = "d1f7f5c2-4187-41da-88fc-b3ae40fa958f"

      allow(HTTParty).to receive(:post) do |_, params|
        expect(params).to include(:body)
        expect(params[:body]).to include(on_behalf_of: "d1f7f5c2-4187-41da-88fc-b3ae40fa958f")
      end.and_return(response)

      subject.post('accounts/create', account_name: "Test Account")
    end

    it "ignores it if it's not a uuid" do
      session.on_behalf_of = "nonsense variable"

      allow(HTTParty).to receive(:post) do |_, params|
        expect(params).to include(:body)
        expect(params[:body]).to eq(account_name: "Test Account")
      end.and_return(response)

      subject.post('accounts/create', account_name: "Test Account")
    end
  end
end
