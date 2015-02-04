module Octodmin
  class Post
    attr_accessor :post

    ATTRIBUTES_FOR_SERIALIZAION = Jekyll::Post::ATTRIBUTES_FOR_LIQUID - %w[
      previous
      next
    ]

    def self.find(id)
      site = Octodmin::Site.new
      site.posts.find { |post| post.identifier == id }
    end

    def self.create(options = {})
      post = Octopress::Post.new(Octopress.site, Jekyll::Utils.stringify_hash_keys(options))
      post.write

      site = Octodmin::Site.new
      site.posts.first
    rescue RuntimeError
    end

    def initialize(post)
      @post = post
      @site = Octodmin::Site.new
    end

    def path
      @post.path
    end

    def identifier
      path.split("/").last.split(".").first
    end

    def serializable_hash
      @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION).merge(
        identifier: identifier,
        dirty: dirty?,
        deleted: deleted?,
      )
    end

    def update(params)
      # Remove old post
      delete

      # Init the new one
      octopost = Octopress::Post.new(Octopress.site, {
        "path" => @post.path,
        "date" => params["date"],
        "title" => params["title"],
        "force" => true,
      })

      options = @site.config["octodmin"]["front_matter"].keys.map do |key|
        [key, params[key]]
      end.to_h

      result = "---\n#{options.map { |k, v| "#{k}: \"#{v}\"" }.join("\n")}\n---\n\n#{params["content"]}\n"
      octopost.instance_variable_set(:@content, result)
      octopost.write

      @post = @site.posts.find do |post|
        File.join(@site.site.source, post.post.path) == octopost.path
      end.post
    end

    def delete
      octopost = octopost_for(@post)
      git = Git.open(Octodmin::App.dir)
      git.lib.send(:command, "rm", ["-f", "--cached", octopost.path])
    rescue Git::GitExecuteError
      File.delete(octopost.path)
    end

    private

    def octopost_for(post)
      Octopress::Post.new(Octopress.site, {
        "path" => post.path,
        "date" => post.to_liquid["date"],
        "title" => post.to_liquid["title"],
      })
    end

    def has_status?(post, status)
      git = Git.open(Octodmin::App.dir)
      path = File.join(@site.source, post.path)

      changed = git.status.public_send(status).keys.map { |path| File.join(Octodmin::App.dir, path) }
      changed.include?(path)
    end

    def dirty?
      has_status?(@post, :untracked) || has_status?(@post, :changed) || deleted?
    end

    def deleted?
      has_status?(@post, :deleted)
    end
  end
end
