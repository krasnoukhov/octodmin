module Octodmin::Views::Syncs
  class Create
    include Octodmin::View
    format :json

    def render
      _raw JSON.dump(syncs: [message.gsub("&#x2F;", "/")])
    end
  end
end
