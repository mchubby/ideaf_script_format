# *ideaf_script_format*

*ideaf_script_format* is a collection of RSpec test units validating parsed file structures.

Input files are Otomate / Idea Factory's VM script format, which carry a `STCM2` or `STCM2L` header.

## Installation

Install dependencies to your ruby installation:

```
$ bundle
```

## Usage

To test on sample corpus (`spec/sample/*`):

```
$ bundle exec rspec
```

To test on custom input paths, set the `files` array in `rspec_runner.rb`, e.g.:

```ruby
files = Dir["C:/Users/Foobar/Documents/myworkdir/*.stcm*"].reject { |f| not File.file?(f) }
```

Then run the test suite:
```
$ bundle exec ruby rspec_runner.rb
```

## Disclaimer

No guarantee is made about accuracy of information. The specification is "mostly verified" statements
based on empirical observation.
