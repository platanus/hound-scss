require "yaml"
require "json"

module Linters
  class Config
    def initialize(content:, default_config_path:, serialize:)
      @custom_config = YAML.safe_load(content) || {}
      @default_config_path = default_config_path
      @serialize = serialize
    end

    def serialize
      if @serialize == "yaml"
        to_hash.to_yaml
      elsif @serialize == "json"
        to_hash.to_json
      end
    end

    private

    attr_reader :custom_config, :default_config_path

    def to_hash
      default_config.merge(custom_config)
    end

    def default_config
      YAML.safe_load(default_content)
    end

    def default_content
      File.read(default_config_path)
    end
  end
end
