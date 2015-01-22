module Octodmin
  class Site
    extend Forwardable
    attr_accessor :site

    def initialize
      @site = Jekyll::Site.new(Jekyll.configuration)
      @site.reset
      @site.read
    end

    def posts
      @site.posts.map { |post| Post.new(post) }
    end
  end
end
