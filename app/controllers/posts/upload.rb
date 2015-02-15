require_relative "manage"

module Octodmin::Controllers::Posts
  class Upload < Manage
    include Octodmin::Action
    expose :upload

    def call(params)
      super

      site = Octodmin::Site.new
      file = params[:file]
      dir  = File.join(site.source, "octodmin", @post.identifier)
      path = File.join(dir, file["filename"])

      FileUtils.mkdir_p(dir)
      FileUtils.cp(file["tempfile"].path, path)

      @upload = path.sub(site.source, "")
    end
  end
end
