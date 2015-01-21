module Octodmin::Controllers::Frontend
  class Index
    include Octodmin::Action
    expose :posts

    def call(params)
      @posts = []
    end
  end
end
