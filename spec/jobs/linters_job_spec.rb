require "jobs/linters_job"

RSpec.describe LintersJob do
  include LintersHelper

  context "when linter name is a single word" do
    it "reports violations" do
      expect_violations_in_file(
        config: "",
        content: "puts 'hello world'\n",
        filename: "foo/bar.rb",
        linter_name: "rubocop",
        violations: [
          {
            line: 1,
            message: "Missing frozen string literal comment.",
          },
        ],
      )
    end
  end

  context "when linter name is multiple words" do
    it "reports violations" do
      expect_violations_in_file(
        config: "",
        content: "%div\n  #main",
        filename: "foo/bar.html.haml",
        linter_name: "haml_lint",
        violations: [
          {
            line: 2,
            message: "Files should end with a trailing newline",
          },
        ],
      )
    end
  end
end
