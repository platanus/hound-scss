require "linters/tokenizer"
require "linters/tslint/tokenizer"

describe Linters::Tslint::Tokenizer do
  describe "#parse" do
    it "parses line numbers when columns provided" do
      input = "test.ts[1, 1]: require statement not part of an import statement"
      expected_message = "require statement not part of an import statement"
      tokenizer = Linters::Tslint::Tokenizer.new

      parsed = tokenizer.parse(input)

      expect(parsed).to eq([{ line: 1, message: expected_message }])
    end
  end
end
