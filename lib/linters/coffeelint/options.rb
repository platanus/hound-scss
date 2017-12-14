require "linters/base/options"
require "linters/coffeelint/tokenizer"

module Linters
  module Coffeelint
    class Options < Linters::Base::Options
      def command
        "#{replace_erb_tags_command} && #{coffeelint_command}"
      end

      def config_filename
        "coffeelint.json"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        if JSON.parse(config).any?
          config
        end
      end

      private

      def replace_erb_tags_command
        "sed -i.bak 's/<%.*%>/123/g' #{filepath}"
      end

      def coffeelint_command
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/coffeelint/bin/coffeelint #{filepath}"
        File.join(path, cmd)
      end
    end
  end
end
