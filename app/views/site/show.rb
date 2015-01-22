module Octodmin::Views::Site
  class Show
    include Octodmin::View
    format :json

    def render
      JSON.dump(sites: site.serializable_hash)
    end
  end
end
