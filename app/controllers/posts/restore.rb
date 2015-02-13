require_relative "manage"

module Octodmin::Controllers::Posts
  class Restore < Manage
    include Octodmin::Action
    expose :post

    def call(params)
      super

      @post.restore
    end
  end
end
