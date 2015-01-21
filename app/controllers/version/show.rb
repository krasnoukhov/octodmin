module Octodmin::Controllers::Version
  class Show
    include Octodmin::Action
    expose :version

    def call(params)
      self.format = :json
      @version = Octodmin::VERSION
    end
  end
end
