module CurrencyCloud
  module Actions
    module Current
      def current
        attrs = client.get("current")
        new(attrs)
      end
    end
  end
end
