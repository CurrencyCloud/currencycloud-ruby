module CurrencyCloud
  module Actions
    module Update
      def self.extended(base)
        base.send(:include, Save) # Private before Ruby 2.1
      end

      # TODO: Add .save instance method, which calls update on changed attributes

      def update(id, params, session = CurrencyCloud.session)
        attrs = client(session).post("#{id}", params)
        new(attrs)
      end
    end
  end
end
