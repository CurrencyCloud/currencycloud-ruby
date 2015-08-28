module CurrencyCloud
  module Actions
    module Retrieve
      def retrieve(id)
        attrs = client.get(id)
        new(attrs)
      end
    end
  end
end
