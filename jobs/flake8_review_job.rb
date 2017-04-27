require "resque"
require "linters/runner"
require "linters/flake8/options"

class Flake8ReviewJob
  @queue = :flake8_review

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: Linters::Flake8::Options.new,
      attributes: attributes,
    )
  end
end
