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
  end
end
