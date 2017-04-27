# frozen_string_literal: true
module Linters
  module Stylelint
    class Tokenizer
      VIOLATION_REGEX = /
        (?<line_number>.+):
        (?<column_number>\d+)\s+
        (?<violation_level>.)\s+
        (?<message>.+\S)
      /x

      def parse(text)
        Linters::Tokenizer.new(text, VIOLATION_REGEX).parse
      end
    end
  end
end
