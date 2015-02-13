module Octodmin::Controllers::Posts
  class Manage
    def call(params)
      self.format = :json
      @post = Octodmin::Post.find(params[:id])
      halt 400, JSON.dump(errors: ["Could not find post"]) unless @post
    end
  end
end
