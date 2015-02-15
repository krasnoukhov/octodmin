module Octodmin::Views::Posts
  class Upload
    include Octodmin::View
    format :json

    def render
      JSON.dump(uploads: [upload])
    end
  end
end
