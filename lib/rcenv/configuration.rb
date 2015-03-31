require 'dotenv'
require_relative '../rcenv'

module RCEnv
  # load dotbash configuration
  #
  # resolve configuration values in priority order:
  #   1. default
  #   2. .env / ENV
  #   3. params
  class Configuration
    attr_accessor :base_path
    attr_accessor :requested_adornments
    attr_accessor :options

    def initialize(opts = {})
      @options = opts
      @requested_adornments = []
      process_options
      self
    end

    def valid?
      valid_base_path?
    end

    protected

    def process_options
      process_dotenv_path
      process_base_path
    end

    # Project NOTE
    #   Q: Should I commit my .env file?
    #   A: $ man .evn  # seriously
    #
    #     Credentials should only be accessible on the machines that need
    #     access to them. Never commit sensitive information to a repository
    #     that is not needed by every development machine and server.
    #
    #     Committing a .env file with development-only settings makes it easy
    #     for other developers to get started on the project without
    #     compromising credentials for other environments.
    #
    #     All the credentials for the developer environment is different from
    #     other deployments and the development credentials do not have access
    #     to confidential data.

    def process_dotenv_path
      if dotenv_path?
        # load where-ever
        Dotenv.load @options[:dotenv_path]
      else
        # load .env
        Dotenv.load
      end
    end

    def dotenv_path?
      @options.key? :dotenv_path
    end

    def process_base_path
      @base_path = if base_path?
                     Pathname.new @options[:base_path]
                   elsif env_base_path?
                     RCEnv.base_path_from_env
                   else
                     RCEnv.base_path_from_home
                   end
    end

    def valid_base_path?
      File.exist? @base_path
    end

    def base_path?
      @options.key? :base_path
    end

    def env_base_path?
      ENV.key? 'RC_HOME'
    end
  end
end

# TODO
# * write kernel.sh with all options set to defaults if one does not exist
