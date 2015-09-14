module CurrencyCloud
  class Conversion
    include CurrencyCloud::Resource

    resource :conversions
    actions :create, :retrieve, :find
  end
end
