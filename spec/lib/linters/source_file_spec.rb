require "spec_helper"
require "linters/source_file"

describe Linters::SourceFile do
  describe "#write_to_dir" do
    it "writes files in the given directory" do
      Dir.mktmpdir do |dir|
        file = Linters::SourceFile.new("file.scss", "")

        file.write_to_dir(dir)

        expect(Dir.entries(dir)).to include("file.scss")
      end
    end
  end
end
