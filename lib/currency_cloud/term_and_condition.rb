module CurrencyCloud
  class TermAndCondition
    include CurrencyCloud::Resource

    resource :terms_and_conditions

    def self.accept(params = {})
      result = client.post("accept", params)
      TermsAndConditions.new(result)
    end
  end
end
