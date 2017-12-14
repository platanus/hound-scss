module Linters
  module Base
    # Base Options class for all linters
    class Options
      # @param config [String] contents of a config file
      # @param filepath [String] relative path to the file being checked
      def initialize(config:, filepath:)
        @config = config
        @filepath = filepath
      end

      # Linter command that will run against a file
      # @return [String] cli command to run
      def command
        not_implemented!(__method__)
      end

      # Filename for configuration file which linter expects by default.
      # @return [String] path and filename of the config file the linter wants
      def config_filename
        not_implemented!(__method__)
      end

      # Object to parse linter output, returning hash with line numbers and
      # messages of the issues
      # @return [#parse] a Tokenizer object implementing `#parse`
      def tokenizer
        not_implemented!(__method__)
      end

      # Returns content of linter's configuration file.  If the configuration
      # needs merging -- the default config needs to be combined with repo's
      # config -- then that work should happen here.
      # @return [Sring, nil] the contents of the config file or nil
      def config_content
        not_implemented!(__method__)
      end

      private

      attr_reader :config, :filepath

      def not_implemented!(method)
        raise NotImplementedError, "implement ##{method} in your Options class"
      end
    end
  end
end
