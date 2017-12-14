require "linters/base/options"
require "linters/slim_lint/tokenizer"

module Linters
  module SlimLint
    class Options < Linters::Base::Options
      def command
        "slim-lint #{filepath}"
      end

      def config_filename
        ".slim-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        config
      end
    end
  end
end
