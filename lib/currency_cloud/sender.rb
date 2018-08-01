module CurrencyCloud
  class Sender
    include CurrencyCloud::Resource

    resource :sender
    actions :retrieve
  end
end
