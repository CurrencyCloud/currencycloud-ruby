module CurrencyCloud
  module Actions

    module Find

      def find(params={}, session = CurrencyCloud.session)
        response = client(session).get("find", params)
        mixin_class.new(self.resource, self, response)
      end

      def first(params={}, session = CurrencyCloud.session)
        entities = find(params.merge(per_page: 1), session) || []
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
