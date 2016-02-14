module CurrencyCloud
  module Actions
    module Save
      def save(session = CurrencyCloud.session)
        return self if changed_attributes.empty?

        params = attributes.select { |attr| changed_attributes.include?(attr) }
        attrs = client(session).post(id, params)
        changed_attributes.clear
        self.attributes = attrs
        self
      end
    end
  end
end
