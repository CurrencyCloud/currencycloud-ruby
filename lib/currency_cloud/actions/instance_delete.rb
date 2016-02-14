module CurrencyCloud
  module Actions
    module InstanceDelete
      def delete(session = CurrencyCloud.session)
        self.class.delete(id, session)
        self
      end
    end
  end
end
