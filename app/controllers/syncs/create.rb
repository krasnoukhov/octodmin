module Octodmin::Controllers::Syncs
  class Create
    include Octodmin::Action
    expose :message

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      git = Git.open(Octodmin::App.dir)

      # Add posts to commit stage
      stage(site, git)

      # Add uploads to commit stage
      git.add(File.join(site.source, "octodmin"))

      # Compute staged paths
      staged = paths(site, git)

      # Pull changes
      git.pull

      # Commit and push changes if any
      if staged.any?
        @message  = "Octodmin sync for #{staged.count} file#{"s" if staged.count > 1}"
        @message += "\n\n#{staged.join("\n")}"

        git.commit(@message)
        git.push
      else
        @message = "Everything is up-to-date"
      end
    rescue Git::GitExecuteError => e
      halt 400, JSON.dump(errors: [e.message])
    ensure
      git.reset(".")
    end

    private

    def stage(site, git)
      deleted = site.status.deleted.keys.map { |path| File.join(Octodmin::App.dir, path) }

      site.posts.each do |post|
        path = File.join(site.source, post.path)
        git.add(path) unless deleted.include?(path)
      end
    end

    def paths(site, git)
      status = site.reset.status

      paths = (
        status.changed.keys +
        status.added.keys +
        status.deleted.keys
      ).map { |path| File.join(Octodmin::App.dir, path) }

      site.posts.select do |post|
        paths.any? { |path| path.end_with?(post.path) }
      end.map(&:path) + paths.map do |path|
        if path.start_with?(File.join(site.source, "octodmin"))
          path.sub(File.join(site.source, ""), "")
        end
      end.compact
    end
  end
end
