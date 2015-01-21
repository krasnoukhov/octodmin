require "octodmin"
require "lotus"
require "json"

module Octodmin
  class App < Lotus::Application
    configure do
      root __dir__

      routes "config/routes"
      load_paths << [
        "controllers",
        "presenters",
        "views",
      ]

      layout :application
      serve_assets true
      assets << [
        "public"
      ]
    end
  end
end
