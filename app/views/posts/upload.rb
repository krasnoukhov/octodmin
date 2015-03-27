module Octodmin::Views::Posts
  class Upload
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(uploads: [upload])
    end
  end
end
