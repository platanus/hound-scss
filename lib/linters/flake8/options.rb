require "linters/base/options"
require "linters/flake8/tokenizer"

module Linters
  module Flake8
    class Options < Linters::Base::Options
      def command
        "flake8"
      end

      def config_filename
        ".flake8"
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
