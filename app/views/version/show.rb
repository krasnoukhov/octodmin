module Octodmin::Views::Version
  class Show
    include Octodmin::View
    format :json

    def render
      JSON.dump(versions: version)
    end
  end
end
