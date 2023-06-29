require 'set'
require_relative './actions'
require_relative './actions_post/find_post'

module CurrencyCloud
  module Resource
    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_reader :changed_attributes

    def initialize(attributes)
      @attributes = attributes
      @changed_attributes = Set.new
      self.accessors = valid_attributes
    end

    def inspect
      "#<#{self.class}:0x#{object_id.to_s(16)} #{@attributes.inspect}>"
    end

    private

    attr_reader :attributes

    def resource
      self.class.resource
    end

    def attributes=(new_values)
      @attributes = new_values.select { |k, _| valid_attributes.include?(k) }
    end

    def valid_attributes
      @attributes.keys
    end

    def changed?
      !@changed_attributes.empty?
    end

    def client
      self.class.client
    end

    def metaclass
      class << self; self; end
    end

    def accessors=(attributes)
      metaclass.instance_eval do
        attributes.each do |attribute|
          define_method(attribute) { @attributes[attribute] }
          define_method("#{attribute}=".to_sym) do |value|
            @attributes[attribute] = value
            @changed_attributes << attribute
          end
        end
      end
    end

    module ClassMethods
      def resource(resource = nil)
        @resource ||= resource
      end

      def actions(*actions)
        actions.each do |action|
          class_eval do
            action_module = CurrencyCloud::Actions.const_get(action.to_s.capitalize)
            extend(action_module)
          end
        end
      end

      def actions_post(*actions)
        actions.each do |action|
          class_eval do
            action_module = CurrencyCloud::ActionsPost.const_get(action.to_s.capitalize)
            extend(action_module)
          end
        end
      end

      def client
        @client ||= Client.new(resource)
      end
    end
  end
end
