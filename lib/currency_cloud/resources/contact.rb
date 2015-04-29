module CurrencyCloud
  class Contact < Resource
    resource :contacts
    actions :create, :retrieve, :find, :update, :current
  end
end