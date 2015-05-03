require 'rubygems'
require 'httparty'
require 'json'

require 'currency_cloud/resource'
lib_path = File.join(File.dirname(__FILE__), '**/*.*')
Dir[lib_path].sort.each { |f| require f}

module CurrencyCloud
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
end
