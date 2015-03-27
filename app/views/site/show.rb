module Octodmin::Views::Site
  class Show
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(sites: site.serializable_hash)
    end
  end
end
