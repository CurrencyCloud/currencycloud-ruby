module CurrencyCloud
  module Actions
    
    module Find

      def find(params={})
        response = request.get("#{self.resource}/find", params)
        mixin_class.new(self.resource, self, response)
      end
       
      def first(params={})
        entities = find((params || {}).merge(per_page: 1))
        return nil if entities.empty?

        entities.first
      end

      private
      def mixin_class
        unless CurrencyCloud.const_defined?(self.resource.capitalize)
          CurrencyCloud.const_set(self.resource.capitalize, Class.new(CurrencyCloud::ResourcefulCollection))
        end
        CurrencyCloud.const_get(self.resource.capitalize)
      end
    end
  end
end