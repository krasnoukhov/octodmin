module Octodmin::Controllers::Syncs
  class Create
    include Octodmin::Action
    expose :message

    def call(params)
      self.format = :json

      site = Octodmin::Site.new
      git = Git.open(Octodmin::App.dir)

      # Add only posts to commit stage
      deleted = git.status.deleted.keys.map { |path| File.join(Octodmin::App.dir, path) }
      site.posts.each do |post|
        path = File.join(site.source, post.path)
        git.add(path) unless deleted.include?(path)
      end

      # Compute message
      status = git.status
      paths = (
        status.changed.keys +
        status.added.keys +
        status.deleted.keys
      ).map { |path| File.join(Octodmin::App.dir, path) }
      staged = site.posts.select do |post|
        paths.any? { |path| path.end_with?(post.path) }
      end.map(&:path)

      @message  = "Octodmin sync for #{staged.count} file#{"s" if staged.count > 1}"
      @message += "\n\n#{staged.join("\n")}"

      git.pull
      git.commit(@message)
      git.push
    rescue Git::GitExecuteError => e
      halt 400, JSON.dump(errors: [e.message])
    ensure
      git.reset(".")
    end
  end
end
