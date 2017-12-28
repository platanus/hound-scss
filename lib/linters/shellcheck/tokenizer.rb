module Linters
  module Shellcheck
    class Tokenizer
      VIOLATION_REGEX = /\A
        \s*In\s
        (?<file>.+)\sline\s
        (?<line_number>\d+).*\^--\s
        (?<code>\w+):\s
        (?<message>.*)
      \z/xm

      def parse(text)
        text.split("\n\n").map { |line| tokenize(line) }.compact
      end

      private

      def tokenize(line)
        matches = VIOLATION_REGEX.match(line)

        if matches
          line_number = matches[:line_number].to_i
          {
            line: line_number,
            message: matches[:message].strip,
          }
        end
      end
    end
  end
end
