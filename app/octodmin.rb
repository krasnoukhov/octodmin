ENV["RACK_ENV"] = ENV["LOTUS_ENV"] ||= "production"

require "octodmin"
require "lotus"
require "json"

begin
  require_relative "./config/sprockets"
rescue LoadError
end

module Octodmin
  class App < Lotus::Application
    configure do
      root __dir__

      routes "config/routes"
      load_paths << [
        "controllers",
        "views",
      ]

      layout :application
    end

    # :nocov:
    configure :production do
      assets << ["public"]
      serve_assets true
      handle_exceptions false
    end

    configure :development do
      handle_exceptions false
    end
    # :nocov:

    configure :test do
      handle_exceptions false
    end
  end
end
