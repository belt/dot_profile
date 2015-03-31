require 'configuration'
require 'popen4'

module RCEnv
  module Adornment
    # sets SSH_AUTH_SOCK and SSH_AGENT_PID
    class Keychain
      attr_accessor :host
      attr_accessor :ssh_id_path
      attr_accessor :ssh_auth_sock, :ssh_agent_pid

      # TODO: generate priority queue
      # TODO: generate dependency machinery i.e. provenance

      def initialize(conf = {})
        @options = conf
        # @ssh_id_path = File.join(ENV['HOME'],'.ssh','id_dsa')
        @ssh_id_path = File.join(ENV['HOME'], '.ssh', 'id_rsa')
        process_options
      end

      def to_sh
        "#{keychain_cmd}\n" \
        ". #{keychain_file} > /dev/null 2>&1\n"
      end

      def ssh_auth_sock
        @ssh_auth_sock ||= ssh_auth_sock_from_keychain
      end

      def ssh_agent_pid
        @ssh_agent_pid ||= ssh_agent_pid_from_keychain
      end

      # ----------------------------------------------------------------------
      # options
      def process_options
        @ssh_id_path = ssh_id_path? ? @options[:ssh_id_path] : @ssh_id_path
        @ssh_agent_pid = ssh_agent_pid? ? @options[:ssh_agent_pid] : @ssh_agent_pid
      end

      # TODO: provenance.socket_hostname provenance.domain
      def host
        @host ||= host? ? @options[:host] : (Socket.gethostname || ENV['HOSTNAME'])
      end

      def ssh_auth_sock
        @ssh_auth_sock ||= ssh_auth_sock? ? @options[:ssh_auth_sock] : ssh_auth_sock_from_keychain
      end

      def ssh_agent_pid
        @ssh_agent_pid ||= ssh_agent_pid? ? @options[:ssh_agent_pid] : ssh_agent_pid_from_keychain
      end

      def host?
        @options.key?(:host)
      end

      def ssh_id_path?
        @options.key?(:ssh_id_path)
      end

      def ssh_auth_sock?
        @options.key?(:ssh_auth_sock)
      end

      def ssh_agent_pid?
        @options.key?(:ssh_agent_pid)
      end

      # ----------------------------------------------------------------------
      # keychain
      # TODO: check bits on keychain_file
      def keychain_file
        File.join ENV['HOME'], ".keychain", "#{host}-sh"
      end

      def keychain_opts
        "--quiet"
      end

      def keychain_cmd
        "keychain #{keychain_opts} #{ssh_id_path}"
      end

      def exec_keychain
        @keychain_status = Open4.popen4 keychain_cmd do |_pid, _std_in, std_out, std_err|
          @keychain_output = std_out.readlines
          @keychain_error = std_err.readlines
        end
      end

      def ssh_auth_sock_from_keychain
        return unless File.exist? keychain_file
        pid, std_in, std_out, std_err = Open4.popen4 'sh'
        std_in.puts ". #{keychain_file}; echo $SSH_AUTH_SOCK"
        std_in.close
        auth_sock = std_out.read.strip
        std_out.close
        std_err.read.strip
        std_err.close
        auth_sock
      end

      def ssh_agent_pid_from_keychain
        return unless File.exist? keychain_file
        pid, std_in, std_out, std_err = Open4.popen4 'sh'
        std_in.puts ". #{keychain_file}; echo $SSH_AGENT_PID"
        std_in.close
        agent_pid = std_out.read.strip
        std_out.close
        std_err.read.strip
        std_err.close
        agent_pid
      end
    end
  end
end
