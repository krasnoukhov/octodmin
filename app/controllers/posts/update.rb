module Octodmin::Controllers::Posts
  class Update
    include Octodmin::Action
    expose :post

    params do
      param :layout, presence: true
      param :title, presence: true
      param :date, presence: true
      param :content, presence: true
    end

    def call(params)
      halt 400, "Required params are not specified" unless params.valid?

      @post = Octodmin::Post.find(params.env["router.params"][:id])
      @post.update(params.env["rack.request.form_hash"].dup)

      self.format = :json
      @post = post
    end
  end
end
