# @cjsx React.DOM

@Posts = React.createClass(
  getInitialState: ->
    { alert: null, loading: false, posts: [] }

  fetchPosts: ->
    return if @state.loading
    @setState(loading: true)
    $.get("/api/posts").always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @setState(alert: null, posts: response.posts)

  handleError: (error) ->
    @setState(alert: "Could not load posts: #{error.statusText} (#{error.status})")

  componentWillMount: ->
    @fetchPosts()
    $(document).on("fetchPosts", @fetchPosts)
    @timer = setInterval(@fetchPosts, 5000)

  componentWillUnmount: ->
    $(document).off("fetchPosts", @fetchPosts)
    clearInterval(@timer)

  render: ->
    <div>
      {<div className="alert alert-danger">{@state.alert}</div> if @state.alert}

      {@state.posts.map((post) ->
        panelClass = if post.added
          "success"
        else if post.changed
          "warning"
        else if post.deleted
          "danger"
        else
          "default"

        <div className="panel panel-#{panelClass}" key={post.id}>
          <div className="panel-heading clearfix">
            <h3 className="panel-title pull-left">{post.title}</h3>
            <div className="pull-right">
              {moment((new Date(post.date)).toISOString()).format("LLL")}
            </div>
          </div>
          <div className="panel-body">
            <div dangerouslySetInnerHTML={{__html: post.excerpt }} />
          </div>
        </div>
      )}
    </div>
)
