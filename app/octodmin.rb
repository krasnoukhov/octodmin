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
  end
end
