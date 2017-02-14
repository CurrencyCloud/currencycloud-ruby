module CurrencyCloud
  module ErrorUtils
    WHITELISTED_PARAMS = [:login_id, :api_key, :token].freeze
    SANITIZED_VALUE = "[FILTERED]".freeze

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

    def whitelist(param_key, param_value)
      WHITELISTED_PARAMS.include?(param_key) ? SANITIZED_VALUE : param_value
    end
  end
end