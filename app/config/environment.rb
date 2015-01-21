require "lotus/setup"
ENV["RACK_ENV"] = ENV["LOTUS_ENV"] ||= "development"

require_relative "../octodmin"
Lotus::Container.configure do
  mount Octodmin::App, at: "/"
end
