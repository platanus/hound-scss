# HoundCI Linters

[![Build Status](https://circleci.com/gh/houndci/linters.svg?style=svg)](https://circleci.com/gh/houndci/linters)

A HoundCI service that handles the code linting.

## Overview

This service pulls jobs off of the queue and uses the appropriate linter to
review a single file for code style violations. Once the code has been reviewed,
this service puts the results back on the queue for [Hound] to process.

This service uses the following linters:

  * [coffeelint](http://www.coffeelint.org) for CoffeeScript
  * [eslint](http://eslint.org) for JavaScript and JSX
  * [haml-lint](https://github.com/brigade/haml-lint) for HAML
  * [jshint](http://jshint.com) for JavaScript
  * [rubocop](https://github.com/bbatsov/rubocop) for Ruby
  * [scss-lint](https://github.com/brigade/scss-lint) for SCSS
  * [slim-lint](https://github.com/sds/slim-lint) for Slim
  * [stylelint](https://github.com/stylelint/stylelint) for SCSS/CSS
  * [credo](https://github.com/rrrene/credo) for Elixir
  * [reek](https://github.com/troessner/reek) for Ruby code smells

To contribute to the Linters codebase, see the [CONTRIBUTING.md] file.

[CONTRIBUTING.md]: CONTRIBUTING.md
[Hound]: https://github.com/houndci/hound
