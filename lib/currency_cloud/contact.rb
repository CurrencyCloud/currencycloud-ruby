module CurrencyCloud
  class Contact
    include CurrencyCloud::Resource

    resource :contacts
    actions :create, :retrieve, :update, :current

    def self.find(params)
      client.post('find', params)
    end

    def first(params = {})
      entities = find(params.merge(per_page: 1)) || []
      entities.first
    end
  end
end
