require "linters/base/options"
require "linters/rubocop/tokenizer"

module Linters
  module Rubocop
    class Options < Linters::Base::Options
      def command
        "rubocop"
      end

      def config_filename
        ".rubocop.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        combined_config.to_yaml
      end

      private

      def combined_config
        Config.new(content: config, default_config_path: "config/rubocop.yml")
      end
    end
  end
end
