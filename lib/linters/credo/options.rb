require "linters/base/options"
require "linters/credo/tokenizer"

module Linters
  module Credo
    class Options < Linters::Base::Options
      def command
        "#{strip_import_config} && " \
          "#{mix("credo #{filepath} --strict --all --format=flycheck")}"
      end

      def config_filename
        ".credo.exs"
      end

      def tokenizer
        Tokenizer.new
      end

      def config_content
        config
      end

      private

      def strip_import_config
        "sed -i.bak '/import_config/d' #{filepath}"
      end

      def mix(command)
        "MIX_EXS=#{mix_exs_path} mix #{command}"
      end

      def mix_exs_path
        File.expand_path("mix.exs", project_root)
      end

      def project_root
        File.expand_path("../../../", __dir__)
      end
    end
  end
end
