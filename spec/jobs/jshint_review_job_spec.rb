require "jobs/jshint_review_job"

RSpec.describe JshintReviewJob do
  include LintersHelper

  context "when file with .js extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.js",
        linter_name: "jshint",
        violations: [
          {
            line: 2,
            message: "Use '===' to compare with 'null'.",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "eqnull": true
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.js",
        linter_name: "jshint",
        violations: [],
      )
    end
  end

  def content
    <<~JS
      function main(a, b) {
        return a == null;
      }
    JS
  end
end
