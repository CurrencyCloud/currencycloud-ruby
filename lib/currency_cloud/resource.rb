require 'set'

module CurrencyCloud
  module Resource
    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_reader :changed_attributes

    def initialize(attributes)
      @attributes = attributes
      @changed_attributes = Set.new
      set_accessors(valid_attributes)
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)} #{@attributes.inspect}>"
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

    def set_accessors(attributes)
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
          self.class_eval do
            action_module = CurrencyCloud::Actions.const_get(action.to_s.capitalize)
            self.extend(action_module)
          end
        end
      end

      def client
        @client ||= Client.new(resource)
      end
    end
  end
end
