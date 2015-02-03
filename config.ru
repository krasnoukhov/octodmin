ENV["RACK_ENV"] = ENV["LOTUS_ENV"] ||= "development"

require "bundler"
Bundler.require

require "octodmin/app"
run Octodmin::App.new(__dir__)
