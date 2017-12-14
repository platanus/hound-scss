module LintersHelper
  def expect_violations_in_file(
    config: "{}",
    content:,
    filename:,
    linter_name:,
    violations:
  )
    attributes = {
      "config" => config,
      "content" => content,
      "commit_sha" => "anything",
      "filename" => filename,
      "patch" => "",
      "linter_name" => linter_name,
      "pull_request_number" => "1",
    }
    allow(Resque).to receive(:enqueue)

    described_class.perform(attributes)

    expect(Resque).to have_received(:enqueue).with(
      CompletedFileReviewJob,
      commit_sha: attributes["commit_sha"],
      filename: attributes["filename"],
      linter_name: attributes["linter_name"],
      patch: attributes["patch"],
      pull_request_number: attributes["pull_request_number"],
      violations: violations,
      error: nil,
    )
  end
end
