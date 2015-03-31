require 'active_support/inflector'
require 'configuration'
require 'adornment/base'

module RCEnv
  # sets up bash RC environment based on initial PATH
  class Base
    attr_accessor :configuration
    attr_accessor :adornments

    def initialize(opts = {})
      @configuration ||= RCEnv::Configuration.new opts
      adornments
      self
    end

    def adornments
      @adornments ||= RCEnv::Adornment::Base.new @configuration
    end

    def valid?
      @configuration.valid?
    end

    def to_sh
      adornments.adornments.map do |adornment, adornment_obj|
        sh = "# adornment.#{adornment}\n"
        sh += (adornment_obj.send(:to_sh) || "")
      end.join("\n")
    end
  end
end
