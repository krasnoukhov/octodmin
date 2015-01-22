module Octodmin
  class Post
    ATTRIBUTES_FOR_SERIALIZAION = Jekyll::Post::ATTRIBUTES_FOR_LIQUID - %w[
      previous
      next
    ]

    def initialize(post)
      @post = post
    end

    def serializable_hash
      @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION)
    end
  end
end
