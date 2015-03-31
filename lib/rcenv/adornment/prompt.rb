require 'configuration'

module RCEnv
  module Adornment
    # chooses a prompt
    # sets PS1 and PROMPT_COMMAND
    # prompt commands are stored in lib/rcenv/adornment/prompts/${FOO}.sh
    #
    # requires: all prompts/${FOO}.sh must implement a ${FOO}_prompt function
    class Prompt
      attr_accessor :prompt_type, :prompt_base_path

      def initialize(conf = {})
        @options = conf
        @prompt_base_path = File.join 'lib', 'rcenv', 'adornment', 'prompts'
        process_options
      end

      def to_sh
        sh = File.read File.join(@prompt_base_path, "#{prompt_type}.sh")
        sh += "\n"
        sh += "PROMPT_COMMAND='#{prompt_type}_prompt'; export PROMPT_COMMAND\n"
      end

      protected

      def process_options
        @prompt_type = prompt_type? ? @options[:prompt_type] : 'simple'
      end

      def prompt_type?
        @options.key?(:prompt_type)
      end
    end
  end
end
