require "jobs/eslint_review_job"

RSpec.describe EslintReviewJob do
  include LintersHelper

  context "when file with .js extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.js",
        linter_name: "eslint",
        violations: [
          {
            line: 2,
            message: "'hello' is defined but never used  no-unused-vars",
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
            "no-unused-vars": "off"
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.js",
        linter_name: "eslint",
        violations: [],
      )
    end
  end

  context "when file with .jsx extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.jsx",
        linter_name: "eslint",
        violations: [
          {
            line: 2,
            message: "'hello' is defined but never used  no-unused-vars",
          },
        ],
      )
    end
  end

  def content
    <<~JS
      'use strict';
      function hello() { }
    JS
  end
end
