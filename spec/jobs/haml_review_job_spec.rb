require "jobs/haml_review_job"

RSpec.describe HamlReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: "%div\n  #main",
        filename: "foo/test.haml",
        linter_name: "haml_lint",
        violations: [
          {
            line: 2,
            message: "Files should end with a trailing newline",
          }
        ],
      )
    end
  end

  context "when directory is excluded" do
    it "reports no violations" do
      expect_violations_in_file(
        config: "exclude: foo/*",
        content: "%div\n  #main",
        filename: "foo/test.haml",
        linter_name: "haml_lint",
        violations: [],
      )
    end
  end

  context "when syntax is invalid" do
    it "reports an error as violation" do
      invalid_content = <<~HAML
        .main
          %div
              %span
      HAML

      expect_violations_in_file(
        content: invalid_content,
        filename: "foo/test.haml",
        linter_name: "haml_lint",
        violations: [
          {
            line: 3,
            message: "The line was indented 2 levels deeper than the previous line.",
          }
        ],
      )
    end
  end
end
