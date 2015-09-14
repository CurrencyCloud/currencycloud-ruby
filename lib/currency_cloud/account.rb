module CurrencyCloud
  class Account
    include CurrencyCloud::Resource

    resource :accounts
    actions :create, :retrieve, :find, :update, :current
  end
end
