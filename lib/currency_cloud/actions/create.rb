module CurrencyCloud
  module Actions
    module Create
      def create(params = {}, session = CurrencyCloud.session)
        attrs = client(session).post("create", params)
        new(attrs)
      end
    end
  end
end
