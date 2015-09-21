require "resque"
require "scss_lint"

require "jobs/completed_file_review_job"
require "configuration"

class ScssReviewJob
  @queue = :scss_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    configuration = Configuration.new(attributes["config"])
    filename = attributes.fetch("filename")
    content = attributes.fetch("content")
    violations = violations(configuration, filename, content)

    Resque.enqueue(
      CompletedFileReviewJob,
      "filename" => filename,
      "commit_sha" => attributes.fetch("commit_sha"),
      "pull_request_number" => attributes.fetch("pull_request_number"),
      "patch" => attributes.fetch("patch"),
      "violations" => violations,
    )
  end

  private

  def self.violations(configuration, filename, content)
    unless configuration.excluded_file?(filename)
      configuration.disable_excluded_linters(filename)
      scss_lint_runner = SCSSLint::Runner.new(configuration.linter_config)
      scss_lint_runner.run([content])

      scss_lint_runner.lints.map do |lint|
        { line: lint.location.line, message: lint.description }
      end
    else
      []
    end
  end
end
