require "spec_helper"
require "configuration"

describe Configuration do
  describe "#linter_config" do
    it "returns linter's config instance" do
      configuration = Configuration.new <<-YAML
        linters:
          BangFormat:
            enabled: false
      YAML

      config = configuration.linter_config

      expect(config).to be_instance_of(SCSSLint::Config)
    end
  end

  describe "#excluded_file?" do
    context "when file is excluded" do
      it "returns true" do
        configuration = Configuration.new <<-YAML
          exclude: "app/assets/*"
        YAML

        result = configuration.excluded_file?("app/assets/test.scss")

        expect(result).to eq true
      end
    end

    context "when file is not excluded" do
      it "returns false" do
        configuration = Configuration.new <<-YAML
          exclude: "app/assets/*"
        YAML

        result = configuration.excluded_file?("lib/assets/test.scss")

        expect(result).to eq false
      end
    end
  end

  describe "#disable_excluded_linters" do
    context "when linter exludes file" do
      it "disables the linter" do
        configuration = Configuration.new <<-YAML
          linters:
            StringQuotes:
              enabled: true
              exclude: "app/assets/*"
        YAML

        configuration.disable_excluded_linters("app/assets/test.scss")

        linter = configuration.linter_config.options["linters"]["StringQuotes"]
        expect(linter["enabled"]).to eq false
      end
    end

    context "when linter does not exclude file" do
      it "leaves the linter enabled" do
        configuration = Configuration.new <<-YAML
          linters:
            StringQuotes:
              enabled: true
              exclude: "app/assets/*"
        YAML

        configuration.disable_excluded_linters("app/views/test.scss")

        linter = configuration.linter_config.options["linters"]["StringQuotes"]
        expect(linter["enabled"]).to eq true
      end
    end
  end
end
