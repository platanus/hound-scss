require "linters/base/options"
require "linters/flog/tokenizer"

module Linters
  module Flog
    class Options < Linters::Base::Options
      def command
        "flog --all --continue --quiet #{filepath}"
      end

      def config_content
        config
      end

      def config_filename
        ".flog"
      end

      def tokenizer
        Tokenizer.new
      end
    end
  end
end
