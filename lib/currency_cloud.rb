require 'rubygems'
require 'httparty'
require 'json'

require 'currency_cloud/resource'
require 'currency_cloud/errors/error_utils'
lib_path = File.join(File.dirname(__FILE__), '**/*.*')
Dir[lib_path].sort.each { |f| require f}

module CurrencyCloud
  UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i

  class << self
     attr_accessor :environment, :login_id, :api_key, :token
  end
  
  def self.session
    @session ||= CurrencyCloud::Session.new(environment, login_id, api_key, token)
  end

  def self.close_session
    @session.close if @session
    true
  end
  
  def self.reset_session
    @session = nil
    @token = nil
  end

  def self.on_behalf_of(contact_id)
    raise CurrencyCloud::GeneralError, '#on_behalf_of has already been set' unless session.on_behalf_of.nil?
    raise CurrencyCloud::GeneralError, 'contact id for on behalf of is not a UUID' unless UUID_REGEX.match(contact_id)

    session.on_behalf_of = contact_id
    yield
  ensure
    session.on_behalf_of = nil
  end
end
