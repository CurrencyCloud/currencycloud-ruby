$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'currency_cloud/version'

spec = Gem::Specification.new do |s|
  s.name = 'currencycloud'
  s.version = CurrencyCloud::Version
  s.summary = 'Ruby SDK for the Currency Cloud API'
  s.description = 'Ruby SDK for the Currency Cloud API - https://connect.currencycloud.com/'
  s.authors = ['Liam McAndrew']
  s.email = ['liam.mcandrew@currencycloud.com']
  s.homepage = 'https://connect.currencycloud.com/documentation/getting-started/introduction'
  s.licenses = ['MIT']

  s.add_dependency('httparty', '~> 0.13.3')
  s.add_dependency('json', '~> 1.8.1')
  
  s.add_development_dependency('rspec', '~> 3.1.0')
  s.add_development_dependency('rake', '~> 10.3')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end