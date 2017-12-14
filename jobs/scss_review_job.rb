require "jobs/linters_job"

class ScssReviewJob < LintersJob
  @queue = :scss_review
end
