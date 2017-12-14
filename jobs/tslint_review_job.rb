require "jobs/linters_job"

class TslintReviewJob < LintersJob
  @queue = :tslint_review
end
