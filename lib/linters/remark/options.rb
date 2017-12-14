require "linters/base/options"
require "linters/remark/tokenizer"

module Linters
  module Remark
    class Options < Linters::Base::Options
      def command
        cmd = "remark-cli/cli.js #{filepath}"
        "NODE_PATH=#{node_modules_path} #{File.join(node_modules_path, cmd)}"
      end

      def config_filename
        ".remarkrc"
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

      def node_modules_path
        File.join(current_path, "node_modules")
      end

      def current_path
        File.expand_path("../../..", __dir__)
      end

      def combined_config
        Config.new(content: config, default_config_path: "config/remarkrc")
      end
    end
  end
end
