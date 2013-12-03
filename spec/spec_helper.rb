require 'singleton_helper'

require 'ideaf_script_format'
include IdeafScriptFormat

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end