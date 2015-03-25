module CurrencyCloud
  module Actions
    
    module Delete

      # TODO: Set state to be deleted
      # TODO: Add .delete instance method
      # TODO: Disable all actionable methods / freeze?
      
      def delete(id)
        response = CurrencyCloud.request(:post, "#{self.resource}/#{id}/delete")
        new(response)
      end
       
    end
    
  end
end