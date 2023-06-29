module CurrencyCloud
  class Contact
    include CurrencyCloud::Resource

    resource :contacts
    actions :create, :retrieve, :update, :current
    actions_post :find
  end
end
