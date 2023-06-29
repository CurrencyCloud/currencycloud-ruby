module CurrencyCloud
  module ActionsPost
    module Find
      def find(params = {})
        response = client.post('find', params)
        mixin_class.new(resource, self, response)
      end

      def first(params = {})
        entities = find(params.merge(per_page: 1)) || []
        entities.first
      end

      private

      def mixin_class
        unless CurrencyCloud.const_defined?(resource.capitalize, false)
          CurrencyCloud.const_set(resource.capitalize, Class.new(CurrencyCloud::ResourcefulCollection))
        end
        CurrencyCloud.const_get(resource.capitalize, false)
      end
    end
  end
end
