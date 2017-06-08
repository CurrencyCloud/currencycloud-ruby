module CurrencyCloud
  module ErrorUtils
    def platform
      base = "ruby-#{RUBY_VERSION}"
      implementation = case RUBY_ENGINE
                       when 'ruby' then ''
                       when 'jruby' then ' (jruby-#{JRUBY_VERSION})"'
                       when 'rbx' then ' (rbx-#{Rubinius::VERSION})'
                       else ' (other)'
                       end
      "#{base}#{implementation}"
    end

    REDACTED_PARAMS = [:api_key, :login_id, :token].freeze

    def redacted_params(params)
      redacted = params.dup

      REDACTED_PARAMS.each do |param|
        if redacted.key? param.to_sym
          redacted[param.to_sym] = 'REDACTED'
        end

        if redacted.key? param.to_s
          redacted[param.to_s] = 'REDACTED'
        end
      end

      redacted
    end
  end
end
