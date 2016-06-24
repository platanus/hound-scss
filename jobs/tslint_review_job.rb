require "resque"
require "linters/runner"
require "linters/tslint/options"

class TslintReviewJob
  @queue = :tslint_review

  def self.perform(attributes)

    Linters::Runner.call(
      linter_options: Linters::Tslint::Options.new,
      attributes: attributes,
    )
  end
end
