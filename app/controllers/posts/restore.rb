module Octodmin::Controllers::Posts
  class Restore
    include Octodmin::Action
    expose :post

    def call(params)
      self.format = :json

      @post = Octodmin::Post.find(params[:id])
      halt 400, JSON.dump(errors: ["Could not find post"]) unless @post
      @post.restore
    end
  end
end
