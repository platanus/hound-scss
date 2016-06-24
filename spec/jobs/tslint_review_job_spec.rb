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
            line: 3,
            message: "type decoration of 'any' is forbidden"
          },
          {
            line: 1,
            message: "unused variable: '_'"
          },
          {
            line: 3,
            message: "unused variable: 'test'"
          },
          {
            line: 1,
            message: "forbidden 'var' keyword, use 'let' or 'const' instead"
          },
          {
            line: 1,
            message: "require statement not part of an import statement"
          }
        ],
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
