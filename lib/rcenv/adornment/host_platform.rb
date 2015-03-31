require 'configuration'

module RCEnv
  module Adornment
    # detects HOST_TYPE, OS_TYPE, and OS_VERSION environment
    class HostPlatform
      attr_accessor :host_type, :os_type, :os_version

      def initialize(_ = Configuration.new)
        process_options
      end

      def to_sh
        "# DOTBASH_HOSTTYPE=#{host_type}; export DOTBASH_HOSTTYPE\n" \
        "# DOTBASH_OSTYPE=#{os_type}; export DOTBASH_OSTYPE\n" \
        "# DOTBASH_OS_VERSION=#{os_version}; export DOTBASH_OS_VERSION\n"
      end

      protected

      def process_options
        host, os = RUBY_PLATFORM.split('-')
        @host_type ||= host
        @os_type = os.sub(/\d.* \z/x, "")
        @os_version = os.match(/\A .*? (\d.*) \z/x).captures[0]
      end
    end
  end
end
