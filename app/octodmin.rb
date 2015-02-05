ENV["RACK_ENV"] = ENV["LOTUS_ENV"] ||= "production"

require "octodmin"
require "lotus"
require "git"
require "json"
require "octopress-deploy"

begin
  require_relative "./config/sprockets"
rescue LoadError
end

module Octodmin
  class App < Lotus::Application
    class << self
      attr_accessor :dir
    end

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

    def initialize(dir = nil)
      raise "Please specify root dir" unless dir
      raise "Attempt to change root dir" if !self.class.dir.nil? && self.class.dir != dir

      self.class.dir = dir
      super()
    end
  end
end
