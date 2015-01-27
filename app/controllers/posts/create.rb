module Octodmin::Controllers::Posts
  class Create
    include Octodmin::Action
    expose :post

    params do
      param :title, presence: true
    end

    def call(params)
      halt 400, "Required param `title` is not specified" unless params.valid?
      post = Octodmin::Post.create(title: params[:title])

      if post
        self.format = :json
        @post = post
      else
        halt 400, "Post with specified `title` already exists"
      end
    end
  end
end
