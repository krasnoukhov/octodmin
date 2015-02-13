require_relative "manage"

module Octodmin::Controllers::Posts
  class Show < Manage
    include Octodmin::Action
    expose :post

    def call(params)
      super
    end
  end
end
