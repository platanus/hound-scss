require "linters/base/options"
require "linters/eslint/tokenizer"

module Linters
  module Eslint
    class Options < Linters::Base::Options
      def command
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/eslint/bin/eslint.js #{filepath}"
        File.join(path, cmd)
      end

      def config_filename
        ".eslintrc"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        combined_config.to_yaml
      end

      private

      def combined_config
        Config.new(content: config, default_config_path: "config/eslintrc")
      end
    end
  end
end
