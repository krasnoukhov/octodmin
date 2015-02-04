module Octodmin::Controllers::Posts
  class Create
    include Octodmin::Action
    expose :post

    params do
      param :title, presence: true
    end

    def call(params)
      self.format = :json
      halt 400, JSON.dump(errors: ["Required param `title` is not specified"]) unless params.valid?

      @post = Octodmin::Post.create(title: params[:title])
      halt 400, JSON.dump(errors: ["Post with specified `title` already exists"]) unless @post
    end
  end
end
