require "octodmin"
require "lotus"
require "json"
require_relative "./config/sprockets"

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
    configure :development do
      handle_exceptions false
    end
    # :nocov:

    configure :test do
      handle_exceptions false
    end
  end
end
