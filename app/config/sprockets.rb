require "sprockets"
require "coffee_script"
require "coffee-react"

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
