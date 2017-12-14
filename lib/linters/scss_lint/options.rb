require "linters/base/options"
require "linters/scss_lint/tokenizer"

module Linters
  module ScssLint
    class Options < Linters::Base::Options
      def command
        "scss-lint #{filepath}"
      end

      def config_filename
        ".scss-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        combined_config.to_yaml
      end

      private

      def combined_config
        Config.new(content: config, default_config_path: "config/scss.yml")
      end
    end
  end
end
