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
  s.required_ruby_version = '>= 2.5'

  s.add_dependency('httparty', '~> 0.21')

  s.add_dependency('json', '>= 2.3', '< 2.7.6')
  s.add_development_dependency('rake', '~> 13.3.0')

  s.add_development_dependency('addressable', '<= 2.9.0')
  s.add_development_dependency('rspec', '~> 3.1')
  s.add_development_dependency('vcr', '~> 6.0.0')
  s.add_development_dependency('webmock', '~> 3.25.0')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
