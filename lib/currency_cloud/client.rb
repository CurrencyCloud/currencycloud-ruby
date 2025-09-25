module CurrencyCloud
  class Client
    def initialize(resource)
      @resource = resource
    end

    def get(url, params = {})
      request.get(build_url(url), params)
    end

    def post(url, params = {}, opts = {})
      request.post(build_url(url), params, opts)
    end

    def build_url(url)
      if url && url != '' && url != '/'
        "#{resource}/#{url}"
      else
        "#{resource}"
      end
    end

    def request
      RequestHandler.new
    end

    private

    attr_reader :resource
  end
end
