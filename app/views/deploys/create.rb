module Octodmin::Views::Deploys
  class Create
    include Octodmin::View
    format :json

    def render
      JSON.dump(deploys: [message])
    end
  end
end
