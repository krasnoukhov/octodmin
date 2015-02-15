module Octodmin::Controllers::Syncs
  class Create
    include Octodmin::Action
    expose :message

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      git = Git.open(Octodmin::App.dir)

      # Add files to commit stage
      stage(site, git)

      # Pull changes
      git.pull

      # Commit and push changes if any
      commit(site, git)
    rescue Git::GitExecuteError => e
      halt 400, JSON.dump(errors: [e.message])
    ensure
      git.reset(".")
    end

    private

    def stage(site, git)
      # Posts
      deleted = site.status.deleted.keys.map { |path| File.join(Octodmin::App.dir, path) }
      site.posts.each do |post|
        path = File.join(site.source, post.path)
        git.add(path) unless deleted.include?(path)
      end

      # Uploads
      git.add(File.join(site.source, "octodmin"))
    end

    def paths(site, git)
      status = site.reset.status
      keys = status.changed.keys + status.added.keys + status.deleted.keys

      keys.sort.reverse.map do |path|
        File.join(Octodmin::App.dir, path).sub(File.join(site.source, ""), "")
      end
    end

    def commit(site, git)
      staged = paths(site, git)

      if staged.any?
        @message  = "Octodmin sync for #{staged.count} file#{"s" if staged.count > 1}"
        @message += "\n\n#{staged.join("\n")}"

        git.commit(@message)
        git.push
      else
        @message = "Everything is up-to-date"
      end
    end
  end
end
