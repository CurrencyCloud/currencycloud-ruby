require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = { record: :new_episodes }
end

require 'currency_cloud'

RSpec.configure do |config|
  config.before do
    CurrencyCloud.login_id = 'development@currencycloud.com'
    CurrencyCloud.api_key = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
    CurrencyCloud.environment = :demonstration
    CurrencyCloud.reset_session
  end
end
