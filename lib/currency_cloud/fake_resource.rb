module CurrencyCloud
  class FakeResource
    include CurrencyCloud::Resource

    def set_something_with_a_long_method()
       wrongly_indented = 'not sure about this var'

      return "there it goes"
    end
  end
end
