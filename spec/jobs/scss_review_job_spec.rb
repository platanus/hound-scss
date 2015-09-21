require "spec_helper"
require "jobs/scss_review_job"

describe ScssReviewJob do
  describe ".perform" do
    context "when double quotes are preferred by default" do
      it "enqueues review job with violations" do
        perform_review

        expect_review_result_with_violations([
          { line: 1, message: "Prefer double-quoted strings" }
        ])
      end
    end

    context "when string quotes rule is disabled" do
      it "enqueues review job without violations" do
        config = <<-YAML
          linters:
            StringQuotes:
              enabled: false
              style: double_quotes
        YAML

        perform_review("config" => config)

        expect_review_result_without_violations
      end
    end

    context "when file is excluded" do
      it "enqueues review job without violations" do
        config = <<-YAML
          exclude:
            - "app/assets/test.scss"
        YAML

        perform_review("config" => config)

        expect_review_result_without_violations
      end
    end

    context "when file is excluded for particular linter" do
      it "does not find vioalations" do
        config = <<-YAML
          linters:
            StringQuotes:
              exclude: "app/assets/test.scss"
        YAML

        perform_review("config" => config)

        expect_review_result_without_violations
      end
    end
  end

  def perform_review(options = {})
    allow(Resque).to receive("enqueue")
    attributes = job_attributes.merge(options).
      merge("content" => ".a { display: 'none'; }\n")
    ScssReviewJob.perform(attributes)
  end

  def expect_review_result_with_violations(violations)
    attributes = job_attributes.merge("violations" => violations)
    expect(Resque).to have_received("enqueue").with(
      CompletedFileReviewJob,
      attributes,
    )
  end

  def expect_review_result_without_violations
    expect_review_result_with_violations([])
  end

  def job_attributes
    {
      "filename" => "app/assets/test.scss",
      "commit_sha" => "123abc",
      "pull_request_number" => "123",
      "patch" => "test",
    }
  end
end
