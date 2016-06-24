require "linters/config"
require "linters/source_file"
require "linters/lint"
require "jobs/completed_file_review_job"

module Linters
  class Runner
    def self.call(*args)
      new(*args).call
    end

    # The attributes are passed from the job and contain the following:
    # - config
    # - content
    # - filename
    # - commit_sha (pass-through)
    # - linter_name (pass-through)
    # - patch (pass-through)
    # - pull_request_number (pass-through)
    def initialize(linter_options:, attributes:)
      @attributes = attributes
      @linter_options = linter_options
    end

    def call
      output = Lint.call(
        command: linter_options.command,
        config_file: config_file,
        source_file: source_file,
      )
      violations = linter_options.tokenizer.parse(output)
      complete_file_review(violations)
    end

    private

    attr_reader :attributes, :linter_options

    def source_file
      SourceFile.new(filename, attributes.fetch("content"))
    end

    def config_file
      SourceFile.new(linter_options.config_filename, config.serialize)
    end

    def config
      Config.new(
        content: attributes.fetch("config"),
        default_config_path: linter_options.default_config_path,
        serialize: linter_options.serializer
      )
    end

    def complete_file_review(violations)
      Resque.enqueue(
        CompletedFileReviewJob,
        commit_sha: attributes.fetch("commit_sha"),
        filename: filename,
        linter_name: attributes.fetch("linter_name"),
        patch: attributes.fetch("patch"),
        pull_request_number: attributes.fetch("pull_request_number"),
        violations: violations,
      )
    end

    def filename
      attributes.fetch("filename")
    end
  end
end
