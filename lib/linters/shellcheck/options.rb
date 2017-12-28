require "linters/base/options"
require "linters/shellcheck/tokenizer"

module Linters
  module Shellcheck
    class Options < Linters::Base::Options
      def command
        "shellcheck #{command_options} #{filepath}"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content; end

      private

      attr_reader :filepath, :raw_config_content

      def command_options
        excluded_rules = parsed_config["exclude"]
        if excluded_rules
          "-e #{excluded_rules.join(',')}"
        end
      end

      def parsed_config
        YAML.safe_load(config).to_h
      end
    end
  end
end
