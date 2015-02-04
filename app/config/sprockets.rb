require "sprockets"
require "coffee_script"
require "coffee-react"
require "bower"

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
    assets_path = File.expand_path("../../assets", __FILE__)
    tmp_path = File.expand_path("../../../tmp", __FILE__)

    sprockets = ::Sprockets::Environment.new
    sprockets.append_path "#{assets_path}/stylesheets"
    sprockets.append_path "#{assets_path}/javascripts"
    sprockets.append_path "#{assets_path}/fonts"
    sprockets.append_path Bower.environment.directory
    sprockets.register_engine ".cjsx", CjsxProcessor
    sprockets.cache = Sprockets::Cache::FileStore.new(tmp_path)
    sprockets
  end
end
