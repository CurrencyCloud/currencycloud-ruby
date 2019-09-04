$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'currency_cloud/version'

Gem::Specification.new do |s|
  s.name = 'currency_cloud'
  s.version = CurrencyCloud::VERSION
  s.summary = 'Ruby SDK for the Currency Cloud API'
  s.description = 'Ruby SDK for the Currency Cloud API - https://www.currencycloud.com/developers/overview/'
  s.authors = ['Liam McAndrew', 'Richard Nienaber']
  s.email = ['liam.mcandrew@currencycloud.com', 'richard.nienaber@currencycloud.com']
  s.homepage = 'https://github.com/Currencycloud/currencycloud-ruby/'
  s.licenses = ['MIT']
  s.required_ruby_version = '>= 1.9'

  s.add_dependency('httparty', '0.14.0')
  s.add_dependency('json', '>= 1.8')

  s.add_development_dependency('addressable', '<= 2.4.0')
  s.add_development_dependency('rake', '~> 10.3')
  s.add_development_dependency('rspec', '~> 3.1')
  s.add_development_dependency('vcr', '~> 3.0.3')
  s.add_development_dependency('webmock', '~> 2.3.2')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
