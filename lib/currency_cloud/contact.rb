module CurrencyCloud
  class Contact
    include CurrencyCloud::Resource

    resource :contacts
    actions :create, :retrieve, :find, :update, :current
  end
end
