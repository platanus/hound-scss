require "jobs/linters_job"

class HamlReviewJob < LintersJob
  @queue = :haml_review
end
