module CurrencyCloud
  module Actions
    module Create
      def create(params={})
        post("create", params)
      end
    end
  end
end