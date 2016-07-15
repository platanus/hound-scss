module Linters
  module Tslint
    class Tokenizer
      VIOLATION_REGEX = /\A
        (?<path>.+)\[
        (?<line_number>\d+),\s
        (?<column_number>\d+)\]:\s+
        (?<message>.+)\n?
      \z/x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
