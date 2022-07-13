module CurrencyCloud
  module Actions
    module Cancel
      def self.extended(base)
        base.send(:include, InstanceDelete) # Private before Ruby 2.1
      end

      # TODO: Disable all actionable methods / freeze?
      def cancel(id)
        attrs = client.post("#{id}/cancel")
        new(attrs)
      end
    end
  end
end
