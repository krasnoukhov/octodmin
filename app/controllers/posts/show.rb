module Octodmin::Controllers::Posts
  class Show
    include Octodmin::Action
    expose :post

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      @post = site.posts.find { |post| post.identifier == params[:id] }
    end
  end
end
