module CurrencyCloud
  module ErrorUtils
    def platform
      base = "ruby-#{RUBY_VERSION}"
      implementation = case RUBY_ENGINE
                       when 'ruby' then ''
                       when 'jruby' then " (jruby-#{JRUBY_VERSION})"
                       when 'rbx' then " (rbx-#{Rubinius::VERSION})"
                       else " (#{RUBY_ENGINE})"
                       end
      "#{base}#{implementation}"
    end

    REDACTED_PARAMS = [:api_key, :login_id, :token].freeze
    REDACTED_STRING = 'REDACTED'.freeze

    def redacted_params(params)
      redacted = params.dup

      REDACTED_PARAMS.each do |param|
        redacted[param.to_sym] = REDACTED_STRING if redacted.key? param.to_sym
        redacted[param.to_s] = REDACTED_STRING if redacted.key? param.to_s
      end

      redacted
    end
  end
end
