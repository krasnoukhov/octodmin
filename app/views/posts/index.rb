module Octodmin::Views::Posts
  class Index
    include Octodmin::View
    format :json

    def render
      JSON.dump(posts: posts)
    end
  end
end
