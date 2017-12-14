require "linters/base/options"
require "linters/tslint/tokenizer"

module Linters
  module Tslint
    class Options < Linters::Base::Options
      def command
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/tslint/bin/tslint #{filepath}"
        File.join(path, cmd)
      end

      def config_filename
        "tslint.json"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        if JSON.parse(config).any?
          config
        else
          combined_config.to_json
        end
      end

      private

      def combined_config
        Config.new(content: config, default_config_path: "config/tslint.json")
      end
    end
  end
end
