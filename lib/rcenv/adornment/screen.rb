require 'configuration'

module RCEnv
  module Adornment
    # sets SCREENDIR
    class Screen
      attr_accessor :screen_dir

      def initialize(conf = {})
        @options = conf
        @screen_dir = File.join(ENV['HOME'], '.screen')
        process_options
      end

      def to_sh
        "SCREENDIR=#{@screen_dir}\n"
      end

      def process_options
        @screen_dir = screen_dir? ? @options[:screen_dir] : @screen_dir
      end

      def screen_dir?
        @options.key?(:screen_dir)
      end

      # TODO: check bits on screen_dir
    end
  end
end
