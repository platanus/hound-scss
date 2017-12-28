# HoundCI Linters

[![Build Status](https://circleci.com/gh/houndci/linters.svg?style=svg)](https://circleci.com/gh/houndci/linters)

A HoundCI service that handles the code linting.

## Overview

This service pulls jobs off of the queue and uses the appropriate linter to
review a single file for code style violations. Once the code has been reviewed,
this service puts the results back on the queue for [Hound] to process.

This service uses the following linters:

  * [coffeelint](http://www.coffeelint.org) for CoffeeScript
  * [credo](https://github.com/rrrene/credo) for Elixir
  * [eslint](http://eslint.org) for JavaScript and JSX
  * [haml-lint](https://github.com/brigade/haml-lint) for HAML
  * [jshint](http://jshint.com) for JavaScript
  * [reek](https://github.com/troessner/reek) for Ruby code smells
  * [remark-lint](https://github.com/wooorm/remark-lint) for Markdown
  * [rubocop](https://github.com/bbatsov/rubocop) for Ruby
  * [sass-lint](https://github.com/sasstools/sass-lint) for SASS
  * [scss-lint](https://github.com/brigade/scss-lint) for SCSS
  * [shellcheck](https://github.com/koalaman/shellcheck) for shell scripts
  * [slim-lint](https://github.com/sds/slim-lint) for Slim
  * [stylelint](https://github.com/stylelint/stylelint) for SCSS/CSS
  * [tslint](https://github.com/palantir/tslint) for TypeScript

To contribute to the Linters codebase, see the [CONTRIBUTING.md] file.

[CONTRIBUTING.md]: CONTRIBUTING.md
[Hound]: https://github.com/houndci/hound
