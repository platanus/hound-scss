require "jobs/reek_review_job"

RSpec.describe ReekReviewJob do
  include LintersHelper

  context "when file contains a smell" do
    it "reports the violation" do
      content = <<~EOS
        class Smelly # IrresponsibleModule: Smelly has no descriptive comment
          def x      # UncommunicativeMethodName: Smelly#x has the name 'x'
            puts 'stinky'
          end
        end
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.rb",
        linter_name: "reek",
        violations: [
          {
            line: 1,
            message: "IrresponsibleModule: Smelly has no descriptive comment. [More info](https://github.com/troessner/reek/blob/master/docs/Irresponsible-Module.md).",
          },
          {
            line: 2,
            message: "UncommunicativeMethodName: Smelly#x has the name 'x'. [More info](https://github.com/troessner/reek/blob/master/docs/Uncommunicative-Method-Name.md).",
          },
        ]
      )
    end
  end
end
