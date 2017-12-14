require "jobs/linters_job"

class JshintReviewJob < LintersJob
  @queue = :jshint_review
end
