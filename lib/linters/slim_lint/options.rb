require "linters/base/options"
require "linters/slim_lint/tokenizer"

module Linters
  module SlimLint
    class Options
      def command(filename)
        "slim-lint #{filename}"
      end

      def config_filename
        ".slim-lint.yml"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        content
      end
    end
  end
end
