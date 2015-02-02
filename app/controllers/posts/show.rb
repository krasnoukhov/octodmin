module Octodmin::Controllers::Posts
  class Show
    include Octodmin::Action
    expose :post

    def call(params)
      self.format = :json

      @post = Octodmin::Post.find(params[:id])
    end
  end
end
