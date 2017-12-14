require "jobs/scss_review_job"

RSpec.describe ScssReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      content = <<~SCSS
        $my-color: #AAA;

        .main {
          color: $my-color;
          display: inline-block
        }
      SCSS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.scss",
        linter_name: "scss_lint",
        violations: [
          {
            line: 1,
            message: "Color `#AAA` should be written as `#aaa`",
          },
          {
            line: 5,
            message: "Declaration should be terminated by a semicolon",
          },
        ],
      )
    end
  end

  context "when directory is excluded" do
    it "reports no violations" do
      expect_violations_in_file(
        config: "exclude: foo/*",
        content: "$color: #aaa\n",
        filename: "foo/test.scss",
        linter_name: "scss_lint",
        violations: [],
      )
    end
  end

  context "when syntax is invalid" do
    it "reports an error as violation" do
      invalid_content = <<~SCSS
        .main {
        {
      SCSS

      expect_violations_in_file(
        content: invalid_content,
        filename: "foo/test.scss",
        linter_name: "scss_lint",
        violations: [
          {
            line: 2,
            message: "Invalid CSS after \".main {\": expected \"}\", was \"{\"",
          },
        ],
      )
    end
  end
end
