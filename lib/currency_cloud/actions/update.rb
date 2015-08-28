module CurrencyCloud
  module Actions
    module Update
      def self.extended(base)
        base.send(:include, Save) # Private before Ruby 2.1
      end

      # TODO: Add .save instance method, which calls update on changed attributes

      def update(id, params)
        attrs = client.post("#{id}", params)
        new(attrs)
      end
    end
  end
end
