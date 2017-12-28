require "resque"
require "linters/runner"

require "linters/coffeelint/options"
require "linters/credo/options"
require "linters/eslint/options"
require "linters/flake8/options"
require "linters/flog/options"
require "linters/haml_lint/options"
require "linters/jshint/options"
require "linters/remark/options"
require "linters/reek/options"
require "linters/rubocop/options"
require "linters/sass_lint/options"
require "linters/scss_lint/options"
require "linters/shellcheck/options"
require "linters/slim_lint/options"
require "linters/stylelint/options"
require "linters/tslint/options"

class LintersJob
  @queue = :linters

  def self.perform(attributes)
    Linters::Runner.call(
      linter_options: linter_options(attributes),
      attributes: attributes,
    )
  end

  def self.linter_options(attributes)
    linter = attributes.fetch("linter_name").split("_").map(&:capitalize).join
    options_class = const_get("Linters::#{linter}::Options")

    options_class.new(
      filepath: attributes.fetch("filename"),
      config: attributes.fetch("config"),
    )
  end
  private_class_method :linter_options
end
