module CurrencyCloud
  module Actions
    
    module Update

      # TODO: Add .save instance method, which calls update on changed attributes

      def update(id, params)
        response = CurrencyCloud.request(:post, "#{self.resource}/#{id}", params)
        new(response)
      end
       
    end
    
  end
end