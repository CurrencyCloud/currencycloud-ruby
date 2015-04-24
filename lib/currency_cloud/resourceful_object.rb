require 'set'

module CurrencyCloud

  class ResourcefulObject
  
    def self.resource(resource=nil)
      @resource ||= resource
    end
    
    def self.actions(*actions)
      @actions ||= actions
      @actions.each do |action|
        self.class_eval do # self.class.instance_eval # metaclass.instance_eval
          action_module = CurrencyCloud::Actions.const_get(action.to_s.capitalize)
          self.extend(action_module)
        end
      end
    end
    
    def initialize(object)
      @object = object
      @changed_attributes = Set.new
      set_accessors(keys)
    end
    
    def keys
      @object.keys
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)} #{@object.inspect}>"
    end
    
    private

    def changed?
      !@changed_attributes.empty?
    end
    
    def metaclass
      class << self; self; end
    end
    
    def set_accessors(keys)
      metaclass.instance_eval do
        keys.each do |key|
          define_method(key) { @object[key] }
          define_method("#{key}=".to_sym) do |value|
            @object[key] = value
            @changed_attributes << key
          end
        end
      end
    end
    
  end
  
end
