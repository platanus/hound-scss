require "jobs/linters_job"

class EslintReviewJob < LintersJob
  @queue = :eslint_review
end
