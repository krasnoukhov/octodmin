module Octodmin::Views::Version
  class Show
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(versions: version)
    end
  end
end
