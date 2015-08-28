module CurrencyCloud
  module Actions
    module Delete
      def self.extended(base)
        base.include(InstanceDelete)
      end

      # TODO: Set state to be deleted
      # TODO: Disable all actionable methods / freeze?
      def delete(id)
        attrs = client.post("#{id}/delete")
        new(attrs)
      end
    end
  end
end
