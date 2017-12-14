# frozen_string_literal: true
require "linters/base/options"
require "linters/sass_lint/tokenizer"

module Linters
  module SassLint
    class Options < Linters::Base::Options
      def command
        path = File.join(File.dirname(__FILE__), "../../..")
        cmd = "/node_modules/sass-lint/bin/sass-lint.js -v -q #{filepath}"
        File.join(path, cmd)
      end

      def config_filename
        ".sass-lint.yml"
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
