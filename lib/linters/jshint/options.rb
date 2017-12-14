require "linters/base/options"
require "linters/jshint/tokenizer"

module Linters
  module Jshint
    class Options < Linters::Base::Options
      def command
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/jshint/bin/jshint #{filepath}"
        File.join(path, cmd)
      end

      def config_filename
        ".jshintrc"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        if JSON.parse(config).any?
          config
        end
      end
    end
  end
end
