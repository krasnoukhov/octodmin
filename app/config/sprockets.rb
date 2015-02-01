require "sprockets"
require "coffee_script"
require "coffee-react"

module Octodmin
  module CjsxProcessor
    VERSION = '1'
    SOURCE_VERSION = ::CoffeeScript::Source.version

    def self.cache_key
      @cache_key ||= [name, SOURCE_VERSION, VERSION].freeze
    end

    def self.call(input)
      data = input[:data]
      input[:cache].fetch(self.cache_key + [data]) do
        ::CoffeeScript.compile(::CoffeeReact.transform(data))
      end
    end
  end

  def self.sprockets
    assets = File.expand_path("../../assets", __FILE__)
    sprockets = ::Sprockets::Environment.new
    sprockets.append_path "#{assets}/stylesheets"
    sprockets.append_path "#{assets}/javascripts"
    sprockets.append_path "#{assets}/fonts"
    sprockets.register_engine ".cjsx", CjsxProcessor
    sprockets
  end
end
