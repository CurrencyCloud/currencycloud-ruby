module CurrencyCloud
  class Contact
    include CurrencyCloud::Resource

    resource :contacts
    actions :create, :retrieve, :update, :current

    def self.find(params)
      client.post('find', params)
    end
  end
end
