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
    end

    def source
      @site.source
    end

    def config
      @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULT_CONFIG, @site.config)
    end

    def serializable_hash
      config
    end

    def posts
      reset
      @site.read
      @site.posts.sort_by { |post| post.to_liquid["date"] }.reverse.map { |post| Post.new(post) }
    end

    def reset
      @status = nil
      @site.reset
      self
    end

    def status
      @status ||= Git.open(Octodmin::App.dir).status
    end
  end
end
