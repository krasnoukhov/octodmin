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
      site.posts.last
    rescue RuntimeError
    end

    def initialize(post)
      @post = post
    end

    def identifier
      @post.path.split("/").last.split(".").first
    end

    def serializable_hash
      @post.to_liquid(ATTRIBUTES_FOR_SERIALIZAION).merge(
        identifier: identifier,
      )
    end

    def update(params)
      # Remove old post
      octopost = Octopress::Post.new(Octopress.site, {
        "path" => @post.path,
        "title" => @post.to_liquid["title"],
      })
      File.delete(octopost.path)

      # Init the new one
      octopost = Octopress::Post.new(Octopress.site, {
        "path" => @post.path,
        "title" => params["title"],
        "force" => true,
      })

      content = params.delete("content")
      date = octopost.convert_date(params.delete("date"))
      options = Jekyll::Utils.stringify_hash_keys(params)
      options["date"] = date

      result = "---\n#{options.map { |k, v| "#{k}: \"#{v}\"" }.join("\n")}\n---\n\n#{content}\n"
      octopost.instance_variable_set(:@content, result)
      octopost.write

      site = Octodmin::Site.new
      @post = site.posts.find do |post|
        File.join(site.site.source, post.post.path) == octopost.path
      end.post
    end
  end
end
