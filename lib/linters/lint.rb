require "linters/system_call"

module Linters
  class Lint
    def self.call(*args)
      new(*args).call
    end

    def initialize(command:, config_file:, source_file:)
      @command = command
      @config_file = config_file
      @source_file = source_file
    end

    def call
      Dir.mktmpdir do |dir|
        source_file.write_to_dir(dir)
        config_file.write_to_dir(dir) if config_file
        run_linter_on_system(dir)
      end
    end

    private

    attr_reader :command, :config_file, :source_file

    def run_linter_on_system(directory)
      system_call(directory).execute
    rescue SystemCall::NonZeroExitStatusError => e
      e.output
    end

    def system_call(directory)
      SystemCall.new(command: command, directory: directory)
    end
  end
end
