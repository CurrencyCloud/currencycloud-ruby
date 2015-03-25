require 'rubygems'
require 'httparty'
require 'json'

require 'currency_cloud/version'
require 'currency_cloud/request_handler'
require 'currency_cloud/response_handler'
require 'currency_cloud/session'
require 'currency_cloud/pagination'

require 'currency_cloud/errors/authentication_error'
require 'currency_cloud/errors/bad_request_error'
require 'currency_cloud/errors/not_found_error'

require 'currency_cloud/actions/create'
require 'currency_cloud/actions/retrieve'
require 'currency_cloud/actions/find'
require 'currency_cloud/actions/delete'
require 'currency_cloud/actions/update'

require 'currency_cloud/resourceful_object'
require 'currency_cloud/resourceful_collection'

require 'currency_cloud/resources/conversion'
require 'currency_cloud/resources/detailed_rate'
require 'currency_cloud/resources/multiple_rates'
require 'currency_cloud/resources/payment'
require 'currency_cloud/resources/beneficiary'
require 'currency_cloud/resources/settlement'
require 'currency_cloud/resources/transactions'

module CurrencyCloud

  class << self
     attr_accessor :environment, :login_id, :api_key
  end
  
  def self.session
    @session ||= CurrencyCloud::Session.new(environment, login_id, api_key)
  end
  
  def self.reset_session
    @session = nil
  end
  
  def self.request(method, route, params={})
    CurrencyCloud::RequestHandler.new(session).send(method, route, params)
  end
  
end
