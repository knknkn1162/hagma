# Hagma

[![CircleCI](https://circleci.com/gh/knknkn1162/hagma.svg?style=shield)](https://circleci.com/gh/knknkn1162/hagma)

NOTE: UNDER development

## What's this?

Hagma is the Ruby library that extends to `Method#source_location` or `Kernel#caller_locations`. It helps you to do the two things:

1. Search the location in the method definition in a class or module that you want.
2. Enumerate instance or singleton methods in the designated class/modules including ancestors.

Let me tell you the reason for making this library: Ruby is the language that defines methods dynamically. That makes it strong, but it may take some time for beginners to find the location in the method definition and its behavior at a glance. So do I!
Hagma is very useful to cope with the difficulty.

## Installation

NOTE: Currently, the library is NOT registered as gem:bow:

```bash
gem install hagma
```

## Usage

+ script

```ruby
# you should require before the other libraries 
require 'hagma'

# require 'other1'
# require 'other2'

# you can also do what you want!
```

+ CLI

(NOTE: There is no implementaion, but has the milestone.)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
