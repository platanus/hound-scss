require "jobs/tslint_review_job"

RSpec.describe TslintReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.ts",
        violations: [
          {
            line: 1,
            message: "Forbidden 'var' keyword, use 'let' or 'const' instead",
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
            "no-unused-variable": false,
            "no-var-keyword": false,
            "no-var-requires": false
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.ts",
        violations: [],
      )
    end
  end

  def content
    <<~TS
      var _ = require("lodash");

      let test: any = 5;
    TS
  end
end
