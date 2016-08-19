require "tmpdir"

module Linters
  class SourceFile
    attr_reader :path, :content

    def initialize(path, content)
      @path = path
      @content = content
    end

    def write_to_dir(dir)
      file_path = File.join(dir, path)
      FileUtils.mkdir_p(File.dirname(file_path))

      File.open(file_path, "w") do |file|
        file.write(content)
      end
    end
  end
end
