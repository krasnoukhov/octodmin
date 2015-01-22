module Octodmin::Controllers::Posts
  class Index
    include Octodmin::Action
    expose :posts

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      @posts = site.posts.map(&:serializable_hash)
    end
  end
end
