module CurrencyCloud
  module Actions
    module Update
      def self.extended(base)
        base.include(Save)
      end

      # TODO: Add .save instance method, which calls update on changed attributes

      def update(id, params)
        attrs = client.post("#{id}", params)
        new(attrs)
      end
    end
  end
end
