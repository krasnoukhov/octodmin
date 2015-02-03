module Octodmin
  class Site
    attr_accessor :site

    DEFAULT_CONFIG = {
      "octodmin" => {
        "front_matter" => {
          "layout" => {
            "type" => "string",
          },
          "title" => {
            "type" => "string",
          },
          "date" => {
            "type" => "date",
          },
        },
      },
    }

    def initialize
      @site = Jekyll::Site.new(Jekyll.configuration)
      @site.reset
    end

    def config
      @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULT_CONFIG, @site.config)
    end

    def serializable_hash
      config
    end

    def posts
      @site.read
      @site.posts.map { |post| Post.new(post) }
    end
  end
end
