require 'active_support/inflector'
require 'configuration'
require 'adornment'

module RCEnv
  module Adornment
    # initializes requested adornments
    # when no adornments are requested, assumes "load all"
    class Base
      attr_accessor :adornments

      def initialize(opts = Configuration.new)
        @options = opts
        @adornments = {}
        require_adornments
        load_adornments
        self
      end

      def available_adornments
        RCEnv::Adornment.available_adornments(@options.base_path)
      end

      def requested_adornments
        adornments? ? @options.requested_adornments : available_adornments
      end

      def adornments?
        !@options.requested_adornments.empty?
      end

      def existing_adornments
        requested_adornments && available_adornments || available_adornments
      end

      def require_adornments
        existing_adornments.each do |adornment|
          require_adornment adornment
        end
      end

      def load_adornments
        existing_adornments.each do |adornment|
          next unless Module.const_get RCEnv::Adornment.namespaced_adornment_class_text(adornment)

          generate_accessor adornment

          initialize_method = :"initialize_with_#{adornment}"
          send initialize_method, @options[adornment.to_sym] if respond_to? initialize_method
          load_adornment adornment
        end
      end

      def generate_accessor(adornment)
        self.class.send :attr_accessor, adornment.to_sym
      end

      def require_adornment(adornment)
        require "adornment/#{adornment}"

      # don't load adornments that don't exist
      rescue => err
        warn "failed to require adornment/#{adornment}"
        raise err
        #  warn err.inspect
      end

      def load_adornment(adornment)
        adornment_sym = adornment.to_sym

        options = @options.options.key?(adornment_sym) ? @options.options[adornment_sym] : {}

        klass = RCEnv::Adornment.adornment_class(adornment)
        if options
          @adornments[:"#{adornment}"] = klass.new(options)
        else
          @adornments[:"#{adornment}"] = klass.new
        end
      end

      def valid?
        @configuration.valid?
      end

      protected

      def to_sh
        fail ":to_sh not implemented"
      end
    end
  end
end
