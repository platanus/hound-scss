require "jobs/credo_review_job"

RSpec.describe CredoReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        config: "",
        content: content,
        filename: "foo/test.ex",
        linter_name: "credo",
        violations: [
          {
            line: 4,
            message: "Found a TODO tag in a comment: # TODO: Fix violations",
          },
          {
            line: 1,
            message: "Avoid negated conditions in if-else blocks.",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        %{
          configs: [
            %{
              name: "default",
              checks: [
                {Credo.Check.Refactor.NegatedConditionsWithElse, false}
              ]
            }
          ]
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.exs",
        linter_name: "credo",
        violations: [
          {
            line: 4,
            message: "Found a TODO tag in a comment: # TODO: Fix violations",
          },
        ],
      )
    end
  end

  context "when another file is imported" do
    it "does not error" do
      content = <<~EOS
        # TODO: Fix
        import_config "config/missing.exs"
      EOS

      expect_violations_in_file(
        config: "",
        content: content,
        filename: "config/foo.exs",
        linter_name: "credo",
        violations: [
          {
            line: 1,
            message: "Found a TODO tag in a comment: # TODO: Fix",
          },
        ],
      )
    end
  end

  def content
    <<~EOS
      if !true do
        IO.puts "Hello"
      else
        # TODO: Fix violations
        IO.puts "World"
      end
    EOS
  end
end
