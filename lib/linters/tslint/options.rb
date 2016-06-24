require "linters/tslint/tokenizer"

module Linters
  module Tslint
    class Options
      def command
        path = File.join(File.dirname(__FILE__), "../../..")
        File.join(path, "/node_modules/tslint/bin/tslint **/*.ts")
      end

      def config_filename
        "tslint.json"
      end

      def default_config_path
        "config/tslint.json"
      end

      def tokenizer
        Tokenizer.new
      end

      def serializer
        "json"
      end
    end
  end
end
