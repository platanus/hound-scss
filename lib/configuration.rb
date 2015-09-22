require "yaml"
require "tempfile"
require "scss_lint"

class Configuration
  DEFAULT_CONFIG_FILE = "config/default.yml"

  def initialize(content)
    @content = content
  end

  def excluded_file?(file_path)
    absolute_path = File.expand_path(file_path, tmpdir)

    linter_config.options.fetch("exclude", []).any? do |exclusion_glob|
      File.fnmatch(exclusion_glob, absolute_path)
    end
  end

  def linter_config
    @linter_config ||= SCSSLint::Config.new(merged_options)
  end

  def disable_excluded_linters(file_path)
    linter_config.options["linters"].each do |_linter_name, options|
      exluded_paths = Array(options.fetch("exclude", []))
      absolute_path = File.expand_path(file_path, tmpdir)

      exluded_paths.each do |exclusion_glob|
        if File.fnmatch(exclusion_glob, absolute_path)
          options["enabled"] = false
        end
      end
    end
  end

  private

  def merged_options
    SCSSLint::Config.send(:smart_merge, base_options, custom_options)
  end

  def custom_options
    SCSSLint::Config.load(file.path, merge_with_default: false).options
  end

  def base_options
    SCSSLint::Config.load(DEFAULT_CONFIG_FILE).options
  end

  def file
    Tempfile.create("").tap do |tempfile|
      tempfile.write(@content)
      tempfile.close
    end
  end

  def tmpdir
    Dir.tmpdir
  end
end
