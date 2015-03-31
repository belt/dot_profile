module RCEnv
  # common functionality for all adornments
  module Adornment
    def self.available_adornments(base_path)
      path = File.join base_path, %w(lib rcenv adornment *)
      (Pathname.glob(path).select(&:file?).map(&:to_s).map do |path|
        Pathname.new(path).basename.sub(/\.rb$/, "").to_s
      end) - %w(base)
    end

    def self.namespaced_adornment_class_text(adornment)
      to_s + "::#{adornment.camelize}"
    end

    def self.adornment_class(adornment)
      namespaced_adornment_class_text(adornment).constantize
    end
  end
end
