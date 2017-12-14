require "jobs/linters_job"

class CredoReviewJob < LintersJob
  @queue = :credo_review
end
