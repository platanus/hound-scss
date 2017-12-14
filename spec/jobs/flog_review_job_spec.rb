require "jobs/flog_review_job"

RSpec.describe FlogReviewJob do
  include LintersHelper

  context "when method in file has a high flog score" do
    it "reports the violation" do
      content = <<~EOS
        class BadFlog
          def some_method
            super
          rescue StandardError => error
            if this(&wat=foo) == true
              that = "something"
            end
          end
        end
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.rb",
        linter_name: "flog",
        violations: [
          {
            line: 2,
            message: "BadFlog#some_method is a complex method",
          },
        ],
      )
    end
  end
end
