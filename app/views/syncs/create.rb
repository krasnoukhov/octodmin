module Octodmin::Views::Syncs
  class Create
    include Octodmin::View
    format :json

    def render
      JSON.dump(syncs: [message])
    end
  end
end
