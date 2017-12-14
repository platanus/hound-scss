require "linters/base/options"
require "linters/reek/tokenizer"

module Linters
  module Reek
    class Options < Linters::Base::Options
      def command
        "reek --single-line --no-progress #{filepath}"
      end

      def config_filename
        ".reek"
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
