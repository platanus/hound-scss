require "jobs/linters_job"

class ReekReviewJob < LintersJob
  @queue = :reek_review
end
