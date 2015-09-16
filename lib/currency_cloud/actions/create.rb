module CurrencyCloud
  module Actions
    module Create
      def create(params = {})
        attrs = client.post("create", params)
        new(attrs)
      end
    end
  end
end
