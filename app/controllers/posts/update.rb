module Octodmin::Controllers::Posts
  class Update
    include Octodmin::Action
    expose :post

    params do
      param :layout, presence: true
      param :title, presence: true
      param :slug, presence: true
      param :date, presence: true
      param :content, presence: true
    end

    def call(params)
      self.format = :json

      @post = Octodmin::Post.find(params.env["router.params"][:id])
      halt 400, JSON.dump(errors: ["Could not find post"]) unless @post
      halt 400, JSON.dump(errors: ["Required params are not specified"]) unless params.valid?
      @post.update(params.env["rack.request.form_hash"].dup)
    end
  end
end
