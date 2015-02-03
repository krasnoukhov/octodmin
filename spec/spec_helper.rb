ENV["RACK_ENV"] = ENV["LOTUS_ENV"] = "test"

require "rubygems"
require "bundler/setup"

Bundler.require(:test)
require "rack/test"

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name "spec"
    add_filter   "spec"
  end
end

$:.unshift "lib"
require "octodmin"
require "octodmin/app"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include JsonSpec::Helpers
end
