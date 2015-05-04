module CurrencyCloud
  module Actions
    
    module Delete

      # TODO: Set state to be deleted
      # TODO: Disable all actionable methods / freeze?
      
      def delete(id)
        post("#{id}/delete")
      end       
    end

    module InstanceDelete
      def delete
        self.class.delete(id)
        self
      end       
    end
  end
end