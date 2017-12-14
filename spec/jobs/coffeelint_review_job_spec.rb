require "jobs/coffeelint_review_job"

RSpec.describe CoffeelintReviewJob do
  include LintersHelper

  context "when file with .coffee extention contains violations" do
    it "reports violations" do
      expect_violations_in_file(
        content: content,
        filename: "foo/test.coffee",
        linter_name: "coffeelint",
        violations: [
          {
            line: 1,
            message: "Class name should be UpperCamelCased. class name: myObj.",
          },
          {
            line: 3,
            message: "Line contains a trailing semicolon.",
          },
        ],
      )
    end
  end

  context "when custom configuraton is provided" do
    it "respects the custom configuration" do
      config = <<~JSON
        {
          "camel_case_classes": {
            "level": "ignore"
          }
        }
      JSON

      expect_violations_in_file(
        config: config,
        content: content,
        filename: "foo/test.js",
        linter_name: "coffeelint",
        violations: [
          {
            line: 3,
            message: "Line contains a trailing semicolon.",
          },
        ],
      )
    end
  end

  context "when file content is long" do
    it "finds violation on the correct line" do
      content = <<~EOS
        class MyClass
          construtor: ->
            foo1()
            foo2()
            foo3()
            foo4()
            foo5()
            foo6()
            foo7()
            foo8()
              foo9()
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.js",
        linter_name: "coffeelint",
        violations: [
          {
            line: 11,
            message: "error: unexpected indentation",
          },
        ],
      )
    end
  end

  context "when file contains erb" do
    it "lints it as coffeescript" do
      content = <<~EOS
        class FooBar
          baz = ->
            <%= @my_variable %>;
      EOS

      expect_violations_in_file(
        content: content,
        filename: "foo/test.coffee",
        linter_name: "coffeelint",
        violations: [
          {
            line: 3,
            message: "Line contains a trailing semicolon.",
          },
        ],
      )
    end
  end

  def content
    <<~EOS
      class myObj
        greet = ->
          'hello world';
    EOS
  end
end
