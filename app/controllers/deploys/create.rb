module Octodmin::Controllers::Deploys
  class Create
    include Octodmin::Action
    expose :message

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      site.process

      options = site.config["octodmin"]["deploys"].first
      Octopress::Deploy.push(options)

      @message = "Deployed successfully"
    rescue SystemExit => e
      halt 400, JSON.dump(errors: [e.message])
    end
  end
end
