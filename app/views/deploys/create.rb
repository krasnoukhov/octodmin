module Octodmin::Views::Deploys
  class Create
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(deploys: [message])
    end
  end
end
