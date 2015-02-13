require_relative "manage"

module Octodmin::Controllers::Posts
  class Destroy < Manage
    include Octodmin::Action
    expose :post

    def call(params)
      super

      @post.delete
    end
  end
end
