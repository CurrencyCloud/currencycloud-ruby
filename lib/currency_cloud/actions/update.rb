module CurrencyCloud
  module Actions
    module Update

      # TODO: Add .save instance method, which calls update on changed attributes

      def update(id, params)
        post("#{id}", params)
      end
    end
  end
end