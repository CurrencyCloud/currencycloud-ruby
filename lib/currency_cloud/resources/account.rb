module CurrencyCloud
  class Account < Resource
    resource :accounts
    actions :create, :retrieve, :find, :update, :current
  end
end