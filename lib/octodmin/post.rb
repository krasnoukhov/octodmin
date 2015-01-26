module Octodmin
  class Post
    attr_accessor :post

    ATTRIBUTES_FOR_SERIALIZAION = Jekyll::Post::ATTRIBUTES_FOR_LIQUID - %w[
      previous
      next
    ]

    def initialize(post)
      @post = post
    end

    def identifier
      @post.id.gsub("/", "_")
    end

    def serializable_hash
      @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION).merge(
        identifier: identifier,
      )
    end
  end
end
