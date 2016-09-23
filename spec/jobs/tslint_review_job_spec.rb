require "jobs/tslint_review_job"

RSpec.describe TslintReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.ts",
        violations: [],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "extends": "tslint:latest",
          "rules": {}
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.ts",
        violations: [
          {
            line: 1,
            message: "Unused variable: '_'",
          },
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
      let _ = require("lodash");
    TS
  end
end
