module CurrencyCloud
  module Actions
    module Delete
      def self.extended(base)
        base.send(:include, InstanceDelete) # Private before Ruby 2.1
      end

      # TODO: Set state to be deleted
      # TODO: Disable all actionable methods / freeze?
      def delete(id, session = CurrencyCloud.session)
        attrs = client(session).post("#{id}/delete")
        new(attrs)
      end
    end
  end
end
