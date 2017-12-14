require "linters/config"
require "linters/source_file"
require "linters/noop_file"
require "linters/lint"
require "linters/tokenizer"
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
      result = Lint.call(
        command: linter_options.command,
        config_file: config_file,
        source_file: source_file,
      )
      violations = linter_options.tokenizer.parse(result.output)

      if violations.empty? && result.error?
        complete_file_review([], error: sanitize_error_output(result.output))
      else
        complete_file_review(violations)
      end
    end

    private

    attr_reader :attributes, :linter_options

    def sanitize_error_output(output)
      temp_path_pattern = %r{/tmp/.+?/|/private/var/folders/.+/.+/T/.+?/}
      output.lines.uniq.join.gsub(temp_path_pattern, "")
    end

    def source_file
      SourceFile.new(filename, attributes.fetch("content"))
    end

    def config_file
      if config_content
        SourceFile.new(linter_options.config_filename, config_content)
      else
        NoopFile.new
      end
    end

    def complete_file_review(violations, error: nil)
      Resque.enqueue(
        CompletedFileReviewJob,
        commit_sha: attributes.fetch("commit_sha"),
        filename: filename,
        linter_name: attributes.fetch("linter_name"),
        patch: attributes.fetch("patch"),
        pull_request_number: attributes.fetch("pull_request_number"),
        violations: violations,
        error: error,
      )
    end

    def filename
      attributes.fetch("filename")
    end

    def config_content
      @_config_content ||= linter_options.config_content
    end
  end
end
