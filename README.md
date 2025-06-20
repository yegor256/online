# Ruby Function to Check If We Are Currently Online

[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/online)](https://www.rultor.com/p/yegor256/online)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/online/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/online/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=yegor256/online)](https://www.0pdd.com/p?name=yegor256/online)
[![Gem Version](https://badge.fury.io/rb/online.svg)](https://badge.fury.io/rb/online)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/online.svg)](https://codecov.io/github/yegor256/online?branch=master)
[![Yard Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/yegor256/online/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/online)](https://hitsofcode.com/view/github/yegor256/online)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/online/blob/master/LICENSE.txt)

First, install it:

```bash
gem install online
```

Then, you can use `online?` global function:

```ruby
require 'online'
if online?
  # do some LIVE testing
end
```

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.0+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
