require "resque"
require "linters/runner"

require "linters/coffeelint/options"
require "linters/credo/options"
require "linters/eslint/options"
require "linters/flake8/options"
require "linters/flog/options"
require "linters/haml_lint/options"
require "linters/jshint/options"
require "linters/reek/options"
require "linters/rubocop/options"
require "linters/scss_lint/options"
require "linters/slim_lint/options"
require "linters/stylelint/options"
require "linters/tslint/options"

class LintersJob
  @queue = :linters

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: linter_options(attributes["linter_name"]),
      attributes: attributes,
    )
  end

  def self.linter_options(linter_name)
    linter = linter_name.split("_").map(&:capitalize).join
    const_get("Linters::#{linter}::Options").new
  end
  private_class_method :linter_options
end
