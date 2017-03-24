# frozen_string_literal: true
require "jobs/linters_job"

RSpec.describe LintersJob do
  include LintersHelper

  let(:linter_name) { "stylelint" }

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.scss",
        linter_name: linter_name,
        violations: [
          {
            line: 1,
            message: "Expected \"#AAA\" to be \"#aaa\"   color-hex-case",
          },
          {
            line: 5,
            message: "Unexpected unit                length-zero-no-unit",
          },
        ],
      )
    end
  end

  context "when directory is excluded" do
    it "reports no violations" do
      rules_to_ignore = <<~JSON
        {
          "rules": {
            "declaration-block-trailing-semicolon": "always"
          },
          "ignoreFiles": "foo/*.scss"
        }
      JSON

      expect_violations_in_file(
        config: rules_to_ignore,
        content: "$color: #aaa\n",
        filename: "foo/test.scss",
        linter_name: linter_name,
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
        linter_name: linter_name,
        violations: [
          {
            line: 2,
            message: "Unclosed block   CssSyntaxError",
          },
        ],
      )
    end
  end

  def content
    <<~SCSS
      $my-color: #AAA;

      .main {
        color: $my-color;
        border: 0px;
      }
    SCSS
  end
end
