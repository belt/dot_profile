require 'configuration'

module RCEnv
  module Adornment
    # sets up the TERM and TERM_PROGRAM environment
    class Terminal
      attr_accessor :term, :term_program

      def initialize(opts = {})
        @options = opts
        process_options
      end

      def to_sh
        terms = ["TERM=#{term}; export TERM"]
        if @term_program
          terms.push "TERM_PROGRAM=#{term_program}; export TERM_PROGRAM"
        end
        terms.join("\n") + "\n"
      end

      protected

      def process_options
        @term = term? ? @options[:term] : env_term
        @term_program = term_program? ? @options[:term_program] : env_program
      end

      def term?
        @options.key?(:term)
      end

      def term_program?
        @options.key?(:term_program)
      end

      def env_term
        ENV['TERM']
      end

      def env_program
        ENV['TERM_PROGRAM'] || ""
      end
    end
  end
end
