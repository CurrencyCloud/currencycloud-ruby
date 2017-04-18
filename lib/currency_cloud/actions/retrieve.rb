module CurrencyCloud
  module Actions
    module Retrieve
      def retrieve(id, session = CurrencyCloud.session)
        attrs = client(session).get(id)
        new(attrs)
      end
    end
  end
end
