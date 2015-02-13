require_relative "manage"

module Octodmin::Controllers::Posts
  class Revert < Manage
    include Octodmin::Action
    expose :post

    def call(params)
      super

      @post.revert
    end
  end
end
