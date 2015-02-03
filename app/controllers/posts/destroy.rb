module Octodmin::Controllers::Posts
  class Destroy
    include Octodmin::Action
    expose :post

    def call(params)
      self.format = :json

      @post = Octodmin::Post.find(params[:id])
      @post.delete
    end
  end
end
