require 'set'

module CurrencyCloud

  class Resource
  
    def self.resource(resource=nil)
      @resource ||= resource
    end
    
    def self.actions(*actions)
      @actions ||= actions
      @actions.each do |action|
        self.class_eval do
          action_module = CurrencyCloud::Actions.const_get(action.to_s.capitalize)
          self.extend(action_module)
        end


        self.send(:include, CurrencyCloud::Actions::Save) if action == :update
        self.send(:include, CurrencyCloud::Actions::InstanceDelete) if action == :delete
      end
    end
    
    attr_reader :changed_attributes
    
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

    def post(url, params={})
      hash = self.class.request.post(self.class.build_url(url), params)

      hash.each do |k, v|
        send("#{k}=", v)
      end
    end

    def self.get(url, params={})
      new(request.get(build_url(url), params))
    end

    def self.post(url, params={})
      new.post(url, params)
    end

    def self.build_url(url)
      "#{self.resource}/#{url}"
    end

    def self.request
      RequestHandler.new
    end
  end
end
