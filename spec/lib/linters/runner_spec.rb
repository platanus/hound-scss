require "resque"
require "linters/runner"
require "linters/rubocop/options"

describe Linters::Runner do
  describe "#call" do
    context "when linter encounters an error" do
      it "enqueues a job with an error" do
        config = <<~EOS
          Style/AlignHash:
            Enabled: true
          Style/MethodCallParentheses:
            Enabled: true
        EOS
        content = <<~EOS
          # frozen_string_literal: true
          {
            hello: 1,
            foo: 2
          }
        EOS
        expected_output = <<~EOS
          .rubocop.yml: Style/AlignHash has the wrong namespace - should be Layout
          Error: The `Style/MethodCallParentheses` cop has been renamed to `Style/MethodCallWithoutArgsParentheses`.
          (obsolete configuration found in .rubocop.yml, please update it)
        EOS
        attributes = {
          "commit_sha" => "foobar",
          "config" => config,
          "content" => content,
          "filename" => "foo.rb",
          "linter_name" => "rubocop",
          "patch" => "",
          "pull_request_number" => "123",
        }
        options = Linters::Rubocop::Options.new(
          config: config,
          filepath: "foo.rb",
        )
        allow(Resque).to receive(:enqueue)

        described_class.call(
          linter_options: options,
          attributes: attributes,
        )

        expect(Resque).to have_received(:enqueue).with(
          CompletedFileReviewJob,
          commit_sha: attributes["commit_sha"],
          filename: attributes["filename"],
          linter_name: attributes["linter_name"],
          patch: attributes["patch"],
          pull_request_number: attributes["pull_request_number"],
          violations: [],
          error: expected_output,
        )
      end

      context "when error output is a recursive stack-trace" do
        it "reports error using its unique lines" do
          attributes = {
            "commit_sha" => "foobar",
            "config" => "",
            "content" => "puts 'hello world'",
            "filename" => "foo.rb",
            "linter_name" => "rubocop",
            "patch" => "",
            "pull_request_number" => "123",
          }
          output = <<~EOS
            something went wrong:
              foo.rb
              foo.rb
              foo.rb
              Stack buffer overflow
          EOS
          command_result = instance_double(
            "CommandResult",
            output: output,
            error?: true,
          )
          options = Linters::Rubocop::Options.new(
            config: "",
            filepath: "foo.rb",
          )
          allow(Resque).to receive(:enqueue)
          allow(Linters::CommandResult).to receive(:new).
            and_return(command_result)

          described_class.call(
            linter_options: options,
            attributes: attributes,
          )

          expect(Resque).to have_received(:enqueue).with(
            CompletedFileReviewJob,
            commit_sha: attributes["commit_sha"],
            filename: attributes["filename"],
            linter_name: attributes["linter_name"],
            patch: attributes["patch"],
            pull_request_number: attributes["pull_request_number"],
            violations: [],
            error: <<~EOS
              something went wrong:
                foo.rb
                Stack buffer overflow
            EOS
          )
        end
      end
    end
  end
end
