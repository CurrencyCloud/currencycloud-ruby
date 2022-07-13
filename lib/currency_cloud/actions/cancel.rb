module CurrencyCloud
  module Actions
    module Cancel
      def self.extended(base)
        base.send(:include, InstanceDelete)
      end

      def cancel(id)
        attrs = client.post("#{id}/cancel")
        new(attrs)
      end
    end
  end
end
