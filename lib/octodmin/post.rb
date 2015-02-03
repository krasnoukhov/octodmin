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
        deleted: deleted?
      )
    end

    def update(params)
      site = Octodmin::Site.new

      # Remove old post
      octopost = octopost_for(@post)
      File.delete(octopost.path)

      # Init the new one
      octopost = Octopress::Post.new(Octopress.site, {
        "path" => @post.path,
        "date" => params["date"],
        "title" => params["title"],
        "force" => true,
      })

      options = site.config["octodmin"]["front_matter"].keys.map do |key|
        [key, params[key]]
      end.to_h

      result = "---\n#{options.map { |k, v| "#{k}: \"#{v}\"" }.join("\n")}\n---\n\n#{params["content"]}\n"
      octopost.instance_variable_set(:@content, result)
      octopost.write

      site = Octodmin::Site.new
      @post = site.posts.find do |post|
        File.join(site.site.source, post.post.path) == octopost.path
      end.post
    end

    def delete
      octopost = octopost_for(@post)
      git = Git.open(Octodmin::App.dir)
      git.lib.send(:command, "rm", ["-f", "--cached", octopost.path])
    end

    private

    def octopost_for(post)
      Octopress::Post.new(Octopress.site, {
        "path" => post.path,
        "date" => post.to_liquid["date"],
        "title" => post.to_liquid["title"],
      })
    end

    def deleted?
      site = Octodmin::Site.new
      git = Git.open(Octodmin::App.dir)

      path = File.join(site.source, @post.path)
      deleted = git.status.deleted.keys.map { |path| File.join(Octodmin::App.dir, path) }

      deleted.include?(path)
    end
  end
end
