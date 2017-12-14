require "jobs/linters_job"

class RubocopReviewJob < LintersJob
  @queue = :rubocop_review
end
