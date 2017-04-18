module CurrencyCloud
  class Client
    def initialize(resource, session = CurrencyCloud.session)
      @resource = resource
      @session = session
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
      RequestHandler.new session
    end

    private

    attr_reader :resource, :session
  end
end
