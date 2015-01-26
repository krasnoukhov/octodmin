module Octodmin
  class Site
    attr_accessor :site

    def initialize
      @site = Jekyll::Site.new(Jekyll.configuration)
      @site.reset
      @site.read
    end

    def serializable_hash
      @site.config
    end

    def posts
      @site.posts.map { |post| Post.new(post) }
    end
  end
end
