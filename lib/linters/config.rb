require "yaml"

module Linters
  class Config
    def initialize(content:, default_config_path: nil)
      @custom_config = YAML.safe_load(content) || {}
      @default_config_path = default_config_path
    end

    def to_yaml
      to_hash.to_yaml
    end

    def to_json
      to_hash.to_json
    end

    private

    attr_reader :custom_config, :default_config_path

    def to_hash
      if default_config_path.nil?
        custom_config
      else
        default_config.merge(custom_config)
      end
    end

    def default_config
      YAML.safe_load(default_content)
    end

    def default_content
      File.read(default_config_path)
    end
  end
end
