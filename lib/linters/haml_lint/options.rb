require "linters/base/options"
require "linters/haml_lint/tokenizer"

module Linters
  module HamlLint
    class Options < Linters::Base::Options
      def command
        "haml-lint #{filepath}"
      end

      def config_filename
        ".haml-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        combined_config.to_yaml
      end

      private

      def combined_config
        Config.new(content: config, default_config_path: "config/haml.yml")
      end
    end
  end
end
