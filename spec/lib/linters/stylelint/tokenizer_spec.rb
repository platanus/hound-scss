# frozen_string_literal: true
require "linters/tokenizer"
require "linters/stylelint/tokenizer"

describe Linters::Stylelint::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns provided" do
      input = "14:9   ✖  Expected single quotes         string-quotes"
      expected_message = "Expected single quotes         string-quotes"
      tokenizer = Linters::Stylelint::Tokenizer.new

      parsed = tokenizer.parse(input)

      expect(parsed).to eq([{ line: 14, message: expected_message }])
    end
  end
end
