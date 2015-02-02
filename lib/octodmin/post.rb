module Octodmin
  class Post
    attr_accessor :post

    ATTRIBUTES_FOR_SERIALIZAION = Jekyll::Post::ATTRIBUTES_FOR_LIQUID - %w[
      previous
      next
    ]

    def self.create(options = {})
      post = Octopress::Post.new(Octopress.site, Jekyll::Utils.stringify_hash_keys(options))
      post.write

      site = Octodmin::Site.new
      site.posts.last
    rescue RuntimeError
    end

    def initialize(post)
      @post = post
    end

    def identifier
      @post.path.split("/").last.split(".").first
    end

    def serializable_hash
      @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION).merge(
        identifier: identifier,
      )
    end
  end
end
