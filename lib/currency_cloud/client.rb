module CurrencyCloud
  class Client
    def initialize(resource)
      @resource = resource
    end

    def get(url, params={})
      request.get(build_url(url), params)
    end

    def post(url, params={})
      request.post(build_url(url), params)
    end

    def build_url(url)
      "#{resource}/#{url}"
    end

    def request
      RequestHandler.new
    end

    private

    attr_reader :resource
  end
end
