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
      site = Octodmin::Site.new

      # Prepare slug
      options["slug"] = slug_for(site, options[:title])

      # Create post
      post = Octopress::Post.new(Octopress.site, Jekyll::Utils.stringify_hash_keys(options))
      post.write

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
      hash = @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION).dup
      @post.render({}, "site" => @site.config)

      hash.merge(
        excerpt: @post.excerpt,
        identifier: identifier,
        added: added?,
        changed: changed?,
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
        "slug" => self.class.slug_for(@site, params["title"]),
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

      # Add/reset post just in case
      git = Git.open(Octodmin::App.dir)
      git.add(octopost.path)
      git.reset(octopost.path)
    end

    def delete
      octopost = octopost_for(@post)
      git = Git.open(Octodmin::App.dir)
      git.lib.send(:command, "rm", ["-f", "--cached", octopost.path])
    rescue Git::GitExecuteError
      File.delete(octopost.path)
    end

    def restore
      return unless deleted?

      octopost = octopost_for(@post)
      git = Git.open(Octodmin::App.dir)
      git.add(octopost.path)
      @site.reset
    end

    private

    def self.slug_for(site, title)
      title.to_slug.transliterate(
        site.config["octodmin"]["transliterate"]
      ).normalize.to_s
    end

    def octopost_for(post)
      Octopress::Post.new(Octopress.site, {
        "path" => post.path,
        "date" => post.date,
        "slug" => post.slug,
        "title" => post.title,
      })
    end

    def has_status?(post, status)
      path = File.join(@site.source, post.path)
      changed = @site.status.public_send(status).keys
      paths = changed.map { |path| File.join(Octodmin::App.dir, path) }
      paths.include?(path)
    end

    def added?
      has_status?(@post, :untracked) && !changed? && !deleted?
    end

    def changed?
      has_status?(@post, :changed)
    end

    def deleted?
      has_status?(@post, :deleted)
    end
  end
end
