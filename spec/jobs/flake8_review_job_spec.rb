require "jobs/flake8_review_job"

RSpec.describe Flake8ReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        config: "",
        content: content,
        filename: "foo/bar.py",
        violations: [
          {
            line: 1,
            message: "'fibo.fib' imported but unused",
          },
          {
            line: 3,
            message: "undefined name 'foo'",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~EOS
        [flake8]
        max-line-length = 80
        ignore =
            # ignore unknown variables
            F821
      EOS

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/bar.py",
        violations: [
          {
            line: 1,
            message: "'fibo.fib' imported but unused",
          },
        ],
      )
    end
  end

  def content
    <<~EOS
      from fibo import fib

      if foo == "":
          print("foo is invalid")
    EOS
  end
end
