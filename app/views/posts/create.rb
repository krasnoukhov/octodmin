module Octodmin::Views::Posts
  class Create
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(posts: post.serializable_hash)
    end
  end
end
