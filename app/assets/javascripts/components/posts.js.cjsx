# @cjsx React.DOM

@Posts = React.createClass(
  getInitialState: ->
    { posts: [] }

  fetchPosts: ->
    $.get("/api/posts").done(@handleSuccess).fail(@handleError)

  handleSuccess: (response) ->
    @setState(posts: response.posts)

  handleError: ->
    alert("Could not load posts")

  componentWillMount: ->
    @fetchPosts()
    setInterval(@fetchPosts, 5000)

  renderPosts: ->
    @state.posts.map((post) ->
      <div className="panel panel-default" key={post.id}>
        <div className="panel-heading">
          <h3 className="panel-title">{post.title}</h3>
        </div>
        <div className="panel-body">{post.content}</div>
        <div className="panel-footer">{post.date}</div>
      </div>
    )

  render: ->
    <div>{@renderPosts()}</div>
)
