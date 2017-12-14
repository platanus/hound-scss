require "jobs/linters_job"

class FlogReviewJob < LintersJob
  @queue = :flog_review
end
