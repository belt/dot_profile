require 'socket'
require 'configuration'

module RCEnv
  module Adornment
    # detects HOSTNAME and DOMAIN environment
    # TODO: warn when hostname contains a dot
    class Provenance
      attr_accessor :hostname, :domain

      def initialize(_ = Configuration.new)
        @hostname = env_hostname || socket_hostname
        @domain = env_domain
      end

      def to_sh
        "HOSTNAME=#{hostname}; export HOSTNAME\n" \
        "DOMAIN=#{domain}; export DOMAIN\n"
      end

      protected

      def env_hostname
        ENV['HOSTNAME'] || 'localhost'
      end

      # uses gethostname / uname system call, therefore host must know its' own
      # name
      def socket_hostname
        Socket.gethostname
      end

      def env_domain
        ENV['DOMAIN'] || 'localdomain'
      end
    end
  end
end
