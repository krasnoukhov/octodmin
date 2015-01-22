module Octodmin::Controllers::Site
  class Show
    include Octodmin::Action
    expose :site

    def call(params)
      self.format = :json

      @site = Octodmin::Site.new
    end
  end
end
