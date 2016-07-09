require "linters/tslint/tokenizer"

module Linters
  module Tslint
    class Options
      def command(filename)
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/tslint/bin/tslint #{filename}"
        File.join(path, cmd)
      end

      def config_filename
        "tslint.json"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content(content)
        config(content).to_json
      end

      private

      def config(content)
        Config.new(content: content, default_config_path: "config/tslint.json")
      end
    end
  end
end
