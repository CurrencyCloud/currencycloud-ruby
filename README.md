[![Gem Version](https://badge.fury.io/rb/currency_cloud.svg)](http://badge.fury.io/rb/currency_cloud) [![Build Status](https://travis-ci.org/CurrencyCloud/currencycloud-ruby.png?branch=master)](https://travis-ci.org/CurrencyCloud/currencycloud-ruby)

# Currencycloud

This is the official Ruby SDK for the Currencycloud API. Additional documentation for each API endpoint can be found at [developer.currencycloud.com][docs].

If you have any queries or you require support, please contact our development team at development@currencycloud.com Please quote your login id in any correspondence as this makes it easier for us to locate your account and give you the support you need.

## Installation

You don't need this source code unless you want to modify the gem. If
you just want to use the library in your application, you should run:

  `gem install currency_cloud`

If you want to build the gem from source:

  `gem build currency_cloud.gemspec`
  

## Supported Ruby versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* MRI 2.0.0
* MRI 2.1.0
* MRI 2.2.0
* MRI 2.3.4
* MRI 2.4.1
* MRI 2.5.3
* MRI 2.6.3
* [JRuby][jruby]
* [Rubinius][rubinius]

# Usage

```ruby
require 'currency_cloud'

## Configure ##
CurrencyCloud.login_id = '<your login id>'
CurrencyCloud.api_key = '<your api key>'
CurrencyCloud.environment = :demonstration # use :production when ready

## Make API calls ##
currencies = CurrencyCloud::Reference.currencies
#[#<CurrencyCloud::Currency:0x3fcb6d03960c {"code"=>"AED", "decimal_places"=>2, "name"=>"United Arab Emirates Dirham"}>,
# #<CurrencyCloud::Currency:0x3fcb6d0390f8 {"code"=>"AUD", "decimal_places"=>2, "name"=>"Australian Dollar"}>,
# #<CurrencyCloud::Currency:0x3fcb6d038d24 {"code"=>"CAD", "decimal_places"=>2, "name"=>"Canadian Dollar"}>,
# <snip .../>
# #<CurrencyCloud::Currency:0x3fcb6d0295b8 {"code"=>"TRY", "decimal_places"=>2, "name"=>"Turkish Lira"}>,
# #<CurrencyCloud::Currency:0x3fcb6d028fc8 {"code"=>"USD", "decimal_places"=>2, "name"=>"United States Dollar"}>,
# #<CurrencyCloud::Currency:0x3fcb6d0288d4 {"code"=>"ZAR", "decimal_places"=>2, "name"=>"South African Rand"}>]

balances = CurrencyCloud::Balance.find

#<CurrencyCloud::Balances:0x007f96da812838
# @collection=
#  [#<CurrencyCloud::Balance:0x3fcb6d4093b8 {"id"=>"5a998e06-3eb7-46d6-ba58-f749864159ce", "account_id"=>"e7483671-5dc6-0132-e126-002219414986", "currency"=>"GBP", "amount"=>"20034.78", "created_at"=>"2014-12-04T09:50:35+00:00", "updated_at"=>"2015-03-23T14:33:37+00:00"}>,
#   #<CurrencyCloud::Balance:0x3fcb6d4089b8 {"id"=>"7b3796d0-35f3-4f47-8554-8020750a8f9d", "account_id"=>"e7483671-5dc6-0132-e126-002219414986", "currency"=>"EUR", "amount"=>"3012.16", "created_at"=>"2014-12-04T09:50:41+00:00", "updated_at"=>"2015-04-13T08:22:50+00:00"}>,
# @pagination=
#  #<CurrencyCloud::Pagination total_entries=5, total_pages=1, current_page=1, per_page=25, previous_page=-1, next_page=-1, order="created_at", order_asc_desc="asc">>
```

## On Behalf Of
If you want to make calls on behalf of another user (e.g. someone who has a sub-account with you), you
can execute certain commands 'on behalf of' the user's contact_id. Here is an example:

```ruby
CurrencyCloud.on_behalf_of("c6ece846-6df1-461d-acaa-b42a6aa74045") do
  beneficiary = CurrencyCloud::Beneficiary.create(<params>)
  conversion = CurrencyCloud::Conversion.create(<params>)
  payment = CurrencyCloud::Payment.create(<params>)
end
```

Alternatively, you can just merge it with an existing params `Hash`, for example:

```ruby
CurrencyCloud::Account.create(account_name: 'My Test User', on_behalf_of: "c6ece846-6df1-461d-acaa-b42a6aa74045")
```

Each of the above transactions will be executed in scope of the limits for that contact and linked to that contact. Note
that the real user who executed the transaction will also be stored.


## Errors
When an error occurs in the API, the library aims to give us much information
as possible. Here is an example:

```yaml
CurrencyCloud::BadRequestError
---
platform: Ruby 1.9.3
request:
  parameters:
    login_id: non-existent-login-id
    api_key: deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
  verb: post
  url: https://devapi.currencycloud.com/v2/authenticate/api
response:
  status_code: 400
  date: Wed, 29 Apr 2015 22:46:53 GMT
  request_id: 2775253392756800903
errors:
- field: api_key
  code: api_key_length_is_invalid
  message: api_key should be 64 character(s) long
  params:
    length: 64
```

This is split into 5 sections:

1. Error Type: In this case `BadRequestError` represents an HTTP 400 error
2. Platform: The Ruby implementation that was used e.g. 'Ruby 2.2' or 'Ruby 1.9.3 (JRuby 1.7.8)''
3. Request: Details about the HTTP request that was made e.g. the POST parameters
4. Response: Details about the HTTP response that was returned e.g. HTTP status code
5. Errors: A list of errors that provide additional information

The final section contains valuable information:

- Field: The parameter that the error is linked to
- Code: A code representing this error
- Message: A human readable message that explains the error
- Params: A hash that contains dynamic parts of the error message for building custom error messages

When troubleshooting API calls with Currencycloud support, including the full
error in any correspondence can be very helpful.

# Development

Test cases can be run with: `bundle exec rspec`. There is also a `Guardfile` that
is useful for continuously rerunning tests while you develop.

## Contributing
**We welcome pull requests from everyone!** Please see [CONTRIBUTING][contr]

Our sincere thanks for [helping us][hof] create the best API for moving money anywhere around the world!

## Dependencies

* [HTTParty][httparty]
* [json][json]

## Versioning

This project uses [semantic versioning][semver]. You can safely
express a dependency on a major version and expect all minor and patch versions
to be backwards compatible.

## Deprecation Policy
Technology evolves quickly and we are always looking for better ways to serve our customers. From time to time we need to make room for innovation by removing sections of code that are no longer necessary. We understand this can be disruptive and consequently we have designed a Deprecation Policy that protects our customers' investment and that allows us to take advantage of modern tools, frameworks and practices in developing software.

Deprecation means that we discourage the use of a feature, design or practice because it has been superseded or is no longer considered efficient or safe but instead of removing it immediately, we mark it as **@deprecated** to provide backwards compatibility and time for you to update your projects. While the deprecated feature remains in the SDK for a period of time, we advise that you replace it with the recommended alternative which is explained in the relevant section of the code.

We remove deprecated features after **three months** from the time of announcement.

The security of our customers' assets is of paramount importance to us and sometimes we have to deprecate features because they may pose a security threat or because new, more secure, ways are available. On such occasions we reserve the right to set a different deprecation period which may range from **immediate removal** to the standard **three months**.

Once a feature has been marked as deprecated, we no longer develop the code or implement bug fixes. We only do security fixes.

### List of features being deprecated
```
(No features are currently being deprecated)
```

# Support
We actively support the latest version of the SDK. We support the immediate previous version on best-efforts basis. All other versions are no longer supported nor maintained.

# Copyright

Copyright (c) 2016-2019 Currencycloud. See [LICENSE][license] for details.

[developer]: https://developer.currencycloud.com/documentation/getting-started/introduction/
[travis]:    https://travis-ci.org/CurrencyCloud/currencycloud-ruby
[jruby]:     http://jruby.org/
[rubinius]:  http://rubini.us/
[httparty]:  https://github.com/jnunemaker/httparty
[json]:      https://github.com/intridea/multi_json
[semver]:    http://semver.org/
[license]:   LICENSE.md
[contr]:     CONTRIBUTING.md
[hof]:       HALL_OF_FAME.md
