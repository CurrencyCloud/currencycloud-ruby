module CurrencyCloud
  module Actions
    module InstanceDelete
      def delete
        self.class.delete(id)
        self
      end
    end
  end
end
