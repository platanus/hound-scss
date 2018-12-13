require "jobs/rubocop_review_job"

RSpec.describe RubocopReviewJob do
  include LintersHelper

  context "when file contains violations" do
    it "reports violations" do
      content = <<~EOS
        # frozen_string_literal: true

        def foo(bar:, baz:)
          bar
        end
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.rb",
        linter_name: "rubocop",
        violations: [
          {
            line: 3,
            message: "Lint/UnusedMethodArgument: Unused method argument - baz.",
          },
        ],
      )
    end
  end

  context "when custom configuration is provided" do
    context "and directory is excluded" do
      it "reports no violations" do
        config = <<~YAML
          AllCops:
            Exclude:
              - "foo/*.rb"
        YAML

        expect_violations_in_file(
          config: config,
          content: "def yo;   42 end",
          filename: "foo/test.rb",
          linter_name: "rubocop",
          violations: [],
        )
      end
    end

    context "and new ruby syntax is used" do
      it "reports relevant violations" do
        config = <<~YAML
          AllCops:
            Exclude:
              - Rakefile
        YAML
        content = <<~EOS
          # frozen_string_literal: true

          def foo(bar:, baz:)
            bar
          end
        EOS

        expect_violations_in_file(
          config: config,
          content: content,
          filename: "foo/test.rb",
          linter_name: "rubocop",
          violations: [
            {
              line: 3,
              message: "Lint/UnusedMethodArgument: Unused method argument - baz.",
            },
          ],
        )
      end
    end

    context "and rubocop-rspec plugin is used" do
      it "reports violations" do
        config = <<~YAML
          require:
            - rubocop-rspec
        YAML
        content = <<~EOS
          # frozen_string_literal: true

          def foo(bar:, baz:)
            bar
          end
        EOS

        expect_violations_in_file(
          config: config,
          content: content,
          filename: "foo/test.rb",
          linter_name: "rubocop",
          violations: [
            {
              line: 3,
              message: "Lint/UnusedMethodArgument: Unused method argument - baz.",
            },
          ],
        )
      end
    end
  end

  context "when syntax is invalid" do
    it "reports an error as violation" do
      expect_violations_in_file(
        content: "def yo 42 end",
        filename: "foo/test.rb",
        linter_name: "rubocop",
        violations: [
          {
            line: 1,
            message: "Lint/Syntax: unexpected token tINTEGER",
          },
        ],
      )
    end
  end
end
