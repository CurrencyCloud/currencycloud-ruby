module CurrencyCloud
  module Actions
    module Save
      def save
        return self if changed_attributes.empty?
        
        params = Hash[changed_attributes.map { |k| [k, self.send(k)] }]
        post(id, params)
        changed_attributes.clear
        self
      end
    end
  end
end