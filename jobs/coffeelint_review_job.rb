require "jobs/linters_job"

class CoffeelintReviewJob < LintersJob
  @queue = :coffeelint_review
end
