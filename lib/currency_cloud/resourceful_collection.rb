module CurrencyCloud
  
  class ResourcefulCollection
    
    include Enumerable
    
    attr_reader :pagination
    
    def initialize(resource, klass, collection)
      @collection = collection[resource.to_s].map { |object| klass.new(object) }
      @collection ||= []
      @pagination = Pagination.new(collection['pagination'])
    end
    
    def each(&block)
      @collection.each do |member|
        block.call(member)
      end
    end
    
    def [](k)
      @collection[k]
    end
    
    def length
      @collection.length
    end
    
  end
  
end