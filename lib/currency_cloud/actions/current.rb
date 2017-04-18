module CurrencyCloud
  module Actions
    module Current
      def current(session = CurrencyCloud.session)
        attrs = client(session).get("current")
        new(attrs)
      end
    end
  end
end
