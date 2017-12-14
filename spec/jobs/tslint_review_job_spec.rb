require "jobs/tslint_review_job"

RSpec.describe TslintReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.ts",
        linter_name: "tslint",
        violations: [
          {
            line: 1,
            message: "Forbidden 'var' keyword, use 'let' or 'const' instead",
          },
          {
            line: 1,
            message: "require statement not part of an import statement",
          },
          {
            line: 1,
            message: "' should be \"",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "rules": {
            "no-var-requires": true
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.ts",
        linter_name: "tslint",
        violations: [
          {
            line: 1,
            message: "require statement not part of an import statement",
          },
        ],
      )
    end
  end

  def content
    <<~TS
      var _ = require('lodash');
    TS
  end
end
