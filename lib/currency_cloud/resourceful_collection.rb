module CurrencyCloud
  class ResourcefulCollection
    include Enumerable

    extend Forwardable
    def_delegators :@collection, :[], :length, :empty?, :each

    attr_reader :pagination

    def initialize(resource, klass, collection)
      @collection = collection[resource.to_s].map { |object| klass.new(object) }
      @pagination = Pagination.new(collection['pagination'])
    end
  end
end
