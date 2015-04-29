module CurrencyCloud
  module Actions
    
    module Delete

      # TODO: Set state to be deleted
      # TODO: Add .delete instance method
      # TODO: Disable all actionable methods / freeze?
      
      def delete(id)
        post("#{id}/delete")
      end       
    end
  end
end