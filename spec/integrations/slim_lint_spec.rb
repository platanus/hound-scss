require "jobs/linters_job"

RSpec.describe LintersJob, "for slim_lint" do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      content = <<~SLIM
        .hello
        \t.world
      SLIM
      expect_violations_in_file(
        config: "",
        content: content,
        filename: "foo/bar.slim",
        linter_name: "slim_lint",
        violations: [
          {
            line: 2,
            message: "Tab detected",
          },
        ],
      )
    end
  end

  context "when directory is excluded" do
    it "reports no violations" do
      expect_violations_in_file(
        config: "exclude: foo/*",
        content: ".hello\n\t.world",
        filename: "foo/bar.slim",
        linter_name: "slim_lint",
        violations: [],
      )
    end
  end

  context "when syntax is invalid" do
    it "reports an error as violation" do
      expect_violations_in_file(
        content: ".header [incomplete",
        filename: "foo/test.slim",
        linter_name: "slim_lint",
        violations: [
          {
            line: 1,
            message: "Expected closing delimiter ]",
          },
        ],
      )
    end
  end
end
